// Демонстрация алгоритмов раздела 3. Сборка из корня проекта:
// g++ -std=c++23 -pthread examples/algorithms.cpp src/{String,PropertyValue,Product,ProductFilter}.cpp -o /tmp/marketplace-demo
#include "../src/BinaryTree.h"
#include "../src/String.h"
#include "../src/ProductFilter.h"
#include "../src/Product.h"
#include "../src/BooleanPropertyValue.h"
#include "../src/IntegerPropertyValue.h"
#include "../src/RealPropertyValue.h"
#include "../src/TextPropertyValue.h"

#include <cassert>
#include <map>
#include <mutex>
#include <numeric>
#include <optional>
#include <set>
#include <stdexcept>
#include <variant>
#include <vector>

namespace demo
{
using SortValue = std::variant<int, double, const PropertyValue*>;

struct Product : ::Product
{
    int id;
    int price; // В копейках.
    int quantity;
    std::vector<int> ratings;

    bool operator<(const Product& other) const { return id < other.id; }

    Product(int id, int price, int quantity, std::vector<int> ratings)
        : id(id), price(price), quantity(quantity), ratings(std::move(ratings)) {}

    double average_rating() const
    {
        if (ratings.empty())
            return 0;
        return std::accumulate(ratings.begin(), ratings.end(), 0.0) / ratings.size();
    }
};

// После успешной вставки объект принадлежит дереву.
template<class T>
void add_entry(BinaryTree<T>& tree, T entry)
{
    auto* object = new T(std::move(entry));
    try
    {
        tree.add(object);
    }
    catch (...)
    {
        delete object;
        throw;
    }
}

struct CartItem
{
    int product_id;
    int quantity;
};

struct OrderItem
{
    int product_id;
    int quantity;
    int unit_price;
};

struct Order
{
    int buyer_id;
    std::vector<OrderItem> items;
};

class Checkout
{
    // Товары принадлежат дереву каталога и живут дольше Checkout.
    std::map<int, Product*> products;
    std::vector<Order> orders;
    std::mutex data_mutex;

public:
    explicit Checkout(std::map<int, Product*> inventory) : products(std::move(inventory)) {}

    bool place_order(int buyer_id, const std::vector<CartItem>& cart)
    {
        if (cart.empty())
        {
            std::cout << "Корзина пуста.\n";
            return false;
        }

        // Один объект Checkout координирует операции только внутри процесса.
        const std::lock_guard lock(data_mutex);
        std::map<int, int> requested;
        for (const auto& item : cart)
        {
            const auto found = products.find(item.product_id);
            if (found == products.end())
            {
                std::cout << "Товар недоступен.\n";
                return false;
            }

            const int stock = found->second->quantity;
            int& total = requested[item.product_id];
            if (item.quantity <= 0 || item.quantity > stock - total)
            {
                std::cout << "Недостаточный остаток или неверное количество.\n";
                return false;
            }
            total += item.quantity;
        }

        Order order{buyer_id, {}};
        for (const auto& [id, quantity] : requested)
            order.items.push_back({id, quantity, products.at(id)->price});

        // Запись в память может выделить память. Остатки меняются только после ее успеха.
        orders.push_back(std::move(order));
        for (const auto& [id, quantity] : requested)
            products.at(id)->quantity -= quantity;
        return true;
    }
};

struct FilteredProduct
{
    const Product* product;
    bool operator<(const FilteredProduct& other) const { return product->id < other.product->id; }
};

struct CategoryProducts
{
    BinaryTree<Product> products;

    void filter(const ProductFilter& filter, BinaryTree<FilteredProduct>& result) const
    {
        result.clear();
        // iterate обходит дерево по ключу и начинает с его минимального элемента.
        for (const Product& product : iterate(products))
            if (filter.matches(product))
                add_entry(result, FilteredProduct{&product});
    }
};

struct PropertyDefinition
{
    int id;
    String name;
};

struct Category
{
    int id;
    std::optional<int> parent_id;
    std::vector<PropertyDefinition> properties;

    void collect_properties(const std::vector<Category>& categories,
                            std::vector<PropertyDefinition>& result) const
    {
        std::vector<PropertyDefinition> collected;
        std::set<int> visited;
        const Category* current = this;
        while (current)
        {
            if (!visited.insert(current->id).second)
                throw std::logic_error("Циклическая связь категорий");

            collected.insert(collected.end(), current->properties.begin(), current->properties.end());
            if (!current->parent_id)
                break;

            const auto parent = std::ranges::find(categories, *current->parent_id, &Category::id);
            if (parent == categories.end())
                throw std::logic_error("Родительская категория отсутствует");
            current = &*parent;
        }
        result = std::move(collected);
    }
};

enum class SortCriterion { Price, Rating, Property };
enum class SortDirection { Ascending, Descending };

std::optional<SortValue> get_sort_value(const Product& product, SortCriterion criterion, int property_id)
{
    switch (criterion)
    {
        case SortCriterion::Price:
            return SortValue{product.price};
        case SortCriterion::Rating:
            return SortValue{product.average_rating()};
        case SortCriterion::Property:
            if (const auto* value = product.get_property_value(property_id))
                return SortValue{value};
            return std::nullopt;
    }
    throw std::invalid_argument("Неизвестный критерий сортировки");
}

// Для одного property_id значения имеют один тип. Вещественные ключи конечны.
// Указатели результата действительны, пока живут товары в дереве каталога.
std::vector<const Product*> sort_products(const BinaryTree<FilteredProduct>& filtered,
                                          SortCriterion criterion, int property_id,
                                          SortDirection direction)
{
    const auto precedes = [&](const FilteredProduct& a, const FilteredProduct& b)
    {
        const auto left = get_sort_value(*a.product, criterion, property_id);
        const auto right = get_sort_value(*b.product, criterion, property_id);
        if (left.has_value() != right.has_value())
            return left.has_value();

        if (left)
        {
            const auto order = criterion == SortCriterion::Property
                ? *std::get<const PropertyValue*>(*left) <=> *std::get<const PropertyValue*>(*right)
                : *left <=> *right;
            if (order < 0 || order > 0)
                return direction == SortDirection::Ascending ? order < 0 : order > 0;
        }
        return a.product->id < b.product->id;
    };

    BinaryTree<FilteredProduct> tree(precedes);
    for (const auto& entry : iterate(filtered))
        add_entry(tree, entry);

    std::vector<const Product*> sorted;
    for (const auto& entry : iterate(tree))
        sorted.push_back(entry.product);
    return sorted;
}
}

int main()
{
    using namespace demo;
    CategoryProducts catalog;
    const ::PropertyDefinition memory(7, String("объём"), PropertyType::Integer);
    const ::PropertyDefinition color(8, String("цвет"), PropertyType::Text);
    const ::PropertyDefinition bluetooth(9, String("Bluetooth"), PropertyType::Boolean);
    const ::PropertyDefinition weight(10, String("масса"), PropertyType::Real, true);

    auto* first = new demo::Product(1, 3200, 5, {4, 5});
    auto* second = new demo::Product(2, 2700, 2, {});
    auto* third = new demo::Product(3, 2500, 1, {});
    catalog.products.add(first);
    catalog.products.add(second);
    catalog.products.add(third);
    first->set_property_value(memory, IntegerPropertyValue(16));
    second->set_property_value(memory, IntegerPropertyValue(8));
    for (auto* product : {first, second})
    {
        product->set_property_value(color, TextPropertyValue(String("белый")));
        product->set_property_value(bluetooth, BooleanPropertyValue(true));
    }
    first->set_property_value(weight, RealPropertyValue(1.25));
    second->set_property_value(weight, RealPropertyValue(2.5));
    third->set_property_value(color, TextPropertyValue(String("чёрный")));
    third->set_property_value(bluetooth, BooleanPropertyValue(false));

    const std::vector<Category> categories{
        {10, std::nullopt, {{8, String("цвет")}}},
        {11, 10, {{7, String("объем")}}},
    };
    std::vector<demo::PropertyDefinition> properties;
    categories[1].collect_properties(categories, properties);
    assert(properties.size() == 2 && properties[0].id == 7 && properties[1].id == 8);

    BinaryTree<FilteredProduct> filtered;
    ProductFilter filter;
    filter.add_condition(IntegerFilterCondition(memory, 8, 16));
    filter.add_condition(TextFilterCondition(color, String("белый")));
    filter.add_condition(BooleanFilterCondition(bluetooth, true));
    filter.add_condition(RealFilterCondition(weight, 1.25, 2.5));
    catalog.filter(filter, filtered);
    assert(filtered.size() == 2);
    const auto by_price = sort_products(filtered, SortCriterion::Price, 0, SortDirection::Ascending);
    assert(by_price.size() == 2 && by_price[0] == second && by_price[1] == first);

    catalog.filter(ProductFilter{}, filtered);
    const auto by_property = sort_products(filtered, SortCriterion::Property, 7, SortDirection::Descending);
    assert(by_property.size() == 3 && by_property[0] == first && by_property[2] == third);
    const auto by_rating = sort_products(filtered, SortCriterion::Rating, 0, SortDirection::Descending);
    assert(by_rating.size() == 3 && by_rating[0] == first && by_rating[1] == second);
    ProductFilter memory_filter;
    memory_filter.add_condition(IntegerFilterCondition(memory, 8, 16));
    catalog.filter(memory_filter, filtered);
    assert(filtered.size() == (INCLUDE_PRODUCTS_WITH_MISSING_PROPERTY ? 3 : 2));

    Checkout checkout({{1, first}, {2, second}});
    const bool empty_order = checkout.place_order(1, {});
    const bool rejected_order = checkout.place_order(1, {{1, 2}, {2, 1}, {2, 2}});
    assert(!empty_order && !rejected_order && first->quantity == 5 && second->quantity == 2);
    const bool placed_order = checkout.place_order(1, {{1, 2}, {2, 2}});
    assert(placed_order && first->quantity == 3 && second->quantity == 0);

    std::cout << "Проверены сбор характеристик, фильтрация, сортировка и оформление заказа.\n";
}

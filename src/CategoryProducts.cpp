#include "CategoryProducts.h"
#include "ProductFilter.h"

const Product& FilteredProduct::get_product() const { return *product; }

bool FilteredProduct::operator<(const FilteredProduct& other) const
{
    return *product < *other.product;
}

bool FilteredProduct::operator==(const FilteredProduct& other) const
{
    return *product == *other.product;
}

void CategoryProducts::filter(const ProductFilter& filter, BinaryTree<FilteredProduct>& result) const
{
    result.clear();
    for (const auto& product : iterate(products))
    {
        if (filter.matches(product))
        {
            auto* entry = new FilteredProduct(product);
            try
            {
                result.add(entry);
            }
            catch (...)
            {
                delete entry;
                throw;
            }
        }
    }
}

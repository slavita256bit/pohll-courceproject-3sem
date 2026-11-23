#include "Product.h"
#include <stdexcept>

void Product::set_property_value(const PropertyDefinition& definition, PropertyOperand value)
{
    if (as_property_value(value).get_type() != definition.get_type())
        throw std::invalid_argument("Значение не соответствует типу характеристики");
    property_values.insert_or_assign(definition.get_id(), std::move(value));
}

const PropertyValue* Product::get_property_value(int property_id) const
{
    const auto it = property_values.find(property_id);
    return it == property_values.end() ? nullptr : &as_property_value(it->second);
}

int Product::get_id() const { return id; }
bool Product::operator<(const Product& other) const { return id < other.id; }
bool Product::operator==(const Product& other) const { return id == other.id; }

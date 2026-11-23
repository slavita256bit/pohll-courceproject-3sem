#include "ProductFilter.h"
#include "Product.h"
#include <stdexcept>

FilterCondition::FilterCondition(const PropertyDefinition& definition, PropertyType type)
    : definition(definition)
{
    if (definition.get_type() != type)
        throw std::invalid_argument("Условие не соответствует типу характеристики");
}

TextFilterCondition::TextFilterCondition(const PropertyDefinition& definition, const String& expected)
    : FilterCondition(definition, PropertyType::Text), expected(expected) {}

bool TextFilterCondition::matches(const PropertyValue& value) const
{
    return value == expected;
}

IntegerFilterCondition::IntegerFilterCondition(const PropertyDefinition& definition, int minimum, int maximum)
    : FilterCondition(definition, PropertyType::Integer), minimum(minimum), maximum(maximum)
{
    if (!(this->minimum <= this->maximum))
        throw std::invalid_argument("Некорректный диапазон целых чисел");
}

bool IntegerFilterCondition::matches(const PropertyValue& value) const
{
    return minimum <= value && value <= maximum;
}

RealFilterCondition::RealFilterCondition(const PropertyDefinition& definition, double minimum, double maximum)
    : FilterCondition(definition, PropertyType::Real), minimum(minimum), maximum(maximum)
{
    if (!(this->minimum <= this->maximum))
        throw std::invalid_argument("Некорректный диапазон дробных чисел");
}

bool RealFilterCondition::matches(const PropertyValue& value) const
{
    return minimum <= value && value <= maximum;
}

BooleanFilterCondition::BooleanFilterCondition(const PropertyDefinition& definition, bool expected)
    : FilterCondition(definition, PropertyType::Boolean), expected(expected) {}

bool BooleanFilterCondition::matches(const PropertyValue& value) const
{
    return value == expected;
}

void ProductFilter::add_condition(FilterConditionValue condition)
{
    conditions.push_back(std::move(condition));
}

bool ProductFilter::matches(const Product& product) const
{
    for (const auto& stored : conditions)
    {
        const auto& condition = std::visit([](const auto& item) -> const FilterCondition& { return item; }, stored);
        const auto& definition = condition.get_definition();
        const auto* value = product.get_property_value(definition.get_id());
        if (!value)
        {
            if (INCLUDE_PRODUCTS_WITH_MISSING_PROPERTY && !definition.is_required())
                continue;
            return false;
        }
        if (!condition.matches(*value))
            return false;
    }
    return true;
}

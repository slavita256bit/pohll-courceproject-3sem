#include "BooleanPropertyValue.h"
#include "IntegerPropertyValue.h"
#include "RealPropertyValue.h"
#include "TextPropertyValue.h"

namespace
{
template<class T>
std::partial_ordering compare(const PropertyValue& left, const PropertyValue& right)
{
    const auto* lhs = dynamic_cast<const T*>(&left);
    const auto* rhs = dynamic_cast<const T*>(&right);
    if (!lhs || !rhs)
        return std::partial_ordering::unordered;
    return std::compare_partial_order_fallback(lhs->get_value(), rhs->get_value());
}
}

std::partial_ordering PropertyValue::operator<=>(const PropertyValue& other) const
{
    if (get_type() != other.get_type())
        return std::partial_ordering::unordered;

    switch (get_type())
    {
        case PropertyType::Text: return compare<TextPropertyValue>(*this, other);
        case PropertyType::Integer: return compare<IntegerPropertyValue>(*this, other);
        case PropertyType::Real: return compare<RealPropertyValue>(*this, other);
        case PropertyType::Boolean: return compare<BooleanPropertyValue>(*this, other);
    }
    return std::partial_ordering::unordered;
}

bool PropertyValue::operator==(const PropertyValue& other) const
{
    return (*this <=> other) == 0;
}

PropertyType TextPropertyValue::get_type() const { return PropertyType::Text; }
const String& TextPropertyValue::get_value() const { return value; }

PropertyType IntegerPropertyValue::get_type() const { return PropertyType::Integer; }
int IntegerPropertyValue::get_value() const { return value; }

PropertyType RealPropertyValue::get_type() const { return PropertyType::Real; }
double RealPropertyValue::get_value() const { return value; }

PropertyType BooleanPropertyValue::get_type() const { return PropertyType::Boolean; }
bool BooleanPropertyValue::get_value() const { return value; }

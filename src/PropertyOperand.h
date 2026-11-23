#pragma once
#include "BooleanPropertyValue.h"
#include "IntegerPropertyValue.h"
#include "RealPropertyValue.h"
#include "TextPropertyValue.h"
#include <variant>

// Храним конкретное значение целиком и сравниваем через общий PropertyValue.
using PropertyOperand = std::variant<TextPropertyValue, IntegerPropertyValue,
                                     RealPropertyValue, BooleanPropertyValue>;

inline const PropertyValue& as_property_value(const PropertyOperand& operand)
{
    return std::visit([](const auto& value) -> const PropertyValue& { return value; }, operand);
}

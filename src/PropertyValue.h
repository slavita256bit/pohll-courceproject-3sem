#pragma once
#include "PropertyDefinition.h"
#include <compare>

class PropertyValue
{
public:
    virtual ~PropertyValue() = default;

    virtual PropertyType get_type() const = 0;
    std::partial_ordering operator<=>(const PropertyValue& other) const;
    bool operator==(const PropertyValue& other) const;
};

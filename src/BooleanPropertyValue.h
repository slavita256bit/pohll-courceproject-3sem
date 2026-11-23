#pragma once
#include "PropertyValue.h"

class BooleanPropertyValue : public PropertyValue
{
private:
    bool value = false;

public:
    explicit BooleanPropertyValue(bool value) : value(value) {}
    PropertyType get_type() const override;
    bool get_value() const;
};

#pragma once
#include "PropertyValue.h"

class IntegerPropertyValue : public PropertyValue
{
private:
    int value = 0;

public:
    explicit IntegerPropertyValue(int value) : value(value) {}
    PropertyType get_type() const override;
    int get_value() const;
};

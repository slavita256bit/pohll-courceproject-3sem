#pragma once
#include "PropertyValue.h"

class RealPropertyValue : public PropertyValue
{
private:
    double value = 0;

public:
    explicit RealPropertyValue(double value) : value(value) {}
    PropertyType get_type() const override;
    double get_value() const;
};

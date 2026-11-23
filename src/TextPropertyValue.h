#pragma once
#include "String.h"
#include "PropertyValue.h"

class TextPropertyValue : public PropertyValue
{
private:
    String value;

public:
    explicit TextPropertyValue(String value) : value(value) {}
    PropertyType get_type() const override;
    const String& get_value() const;
};

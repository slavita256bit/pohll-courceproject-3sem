#pragma once
#include "FilterSettings.h"
#include "PropertyOperand.h"
#include <vector>

class Product;

class FilterCondition
{
private:
    PropertyDefinition definition;

protected:
    FilterCondition(const PropertyDefinition& definition, PropertyType type);

public:
    virtual ~FilterCondition() = default;
    const PropertyDefinition& get_definition() const { return definition; }
    virtual bool matches(const PropertyValue& value) const = 0;
};

class TextFilterCondition : public FilterCondition
{
private:
    TextPropertyValue expected;

public:
    TextFilterCondition(const PropertyDefinition& definition, const String& expected);
    bool matches(const PropertyValue& value) const override;
};

class IntegerFilterCondition : public FilterCondition
{
private:
    IntegerPropertyValue minimum;
    IntegerPropertyValue maximum;

public:
    IntegerFilterCondition(const PropertyDefinition& definition, int minimum, int maximum);
    bool matches(const PropertyValue& value) const override;
};

class RealFilterCondition : public FilterCondition
{
private:
    RealPropertyValue minimum;
    RealPropertyValue maximum;

public:
    RealFilterCondition(const PropertyDefinition& definition, double minimum, double maximum);
    bool matches(const PropertyValue& value) const override;
};

class BooleanFilterCondition : public FilterCondition
{
private:
    BooleanPropertyValue expected;

public:
    BooleanFilterCondition(const PropertyDefinition& definition, bool expected);
    bool matches(const PropertyValue& value) const override;
};

using FilterConditionValue = std::variant<TextFilterCondition, IntegerFilterCondition,
                                          RealFilterCondition, BooleanFilterCondition>;

class ProductFilter
{
private:
    std::vector<FilterConditionValue> conditions;

public:
    void add_condition(FilterConditionValue condition);
    bool matches(const Product& product) const;
};

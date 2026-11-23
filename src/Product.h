#pragma once
#include "String.h"
#include "PropertyOperand.h"
#include <map>

class Product
{
private:
    int id = 0;
    int category_id = 0;
    String name;
    String description;
    int price = 0;
    int quantity = 0;
    String brand;
    bool active = true;
    std::map<int, PropertyOperand> property_values;

public:
    int get_id() const;
    int get_quantity() const;
    void set_property_value(const PropertyDefinition& definition, PropertyOperand value);
    const PropertyValue* get_property_value(int property_id) const;
    void decrease_quantity(int amount);
    bool operator<(const Product& other) const;
    bool operator==(const Product& other) const;
};

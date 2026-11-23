#pragma once
#include "String.h"

enum class PropertyType
{
    Text,
    Integer,
    Real,
    Boolean
};

class PropertyDefinition
{
private:
    int id = 0;
    String name;
    PropertyType type = PropertyType::Text;
    bool required = false;

public:
    PropertyDefinition() = default;
    PropertyDefinition(int id, const String& name, PropertyType type, bool required = false)
        : id(id), name(name), type(type), required(required) {}

    int get_id() const { return id; }
    PropertyType get_type() const { return type; }
    bool is_required() const { return required; }
};

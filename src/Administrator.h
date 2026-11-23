#pragma once
#include "User.h"

class Category;
class PropertyDefinition;

class Administrator : public User
{
public:
    void add_category(const Category& category);
    void edit_category(const Category& category);
    void add_property(int category_id, const PropertyDefinition& property);
};

#pragma once
#include "String.h"
#include "PropertyDefinition.h"
#include <vector>

class Category
{
private:
    int id = 0;
    int parent_id = 0;
    String name;
    std::vector<PropertyDefinition> properties;

public:
    void collect_properties(const std::vector<Category>& categories,
                            std::vector<PropertyDefinition>& result) const;
};

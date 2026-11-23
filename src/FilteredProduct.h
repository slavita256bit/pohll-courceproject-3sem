#pragma once
#include "Product.h"

class FilteredProduct
{
private:
    const Product* product = nullptr;

public:
    explicit FilteredProduct(const Product& product) : product(&product) {}
    const Product& get_product() const;
    bool operator<(const FilteredProduct& other) const;
    bool operator==(const FilteredProduct& other) const;
};

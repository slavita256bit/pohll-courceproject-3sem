#pragma once
#include "BinaryTree.h"
#include "FilteredProduct.h"
#include "Product.h"

class ProductFilter;

class CategoryProducts
{
private:
    int category_id = 0;
    BinaryTree<Product> products;

public:
    void filter(const ProductFilter& filter, BinaryTree<FilteredProduct>& result) const;
};

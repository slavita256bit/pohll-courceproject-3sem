#pragma once
#include "CartItem.h"
#include <vector>

class Cart
{
private:
    int buyer_id = 0;
    std::vector<CartItem> items;

public:
    void add_product(int product_id, int quantity);
    void change_quantity(int product_id, int quantity);
    void remove_product(int product_id);
};

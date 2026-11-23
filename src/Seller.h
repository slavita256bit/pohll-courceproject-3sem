#pragma once
#include "User.h"

class Product;

class Seller : public User
{
public:
    void add_product(const Product& product);
    void edit_product(const Product& product);
    void remove_product(int product_id);
    void confirm_order(int order_id);
    void reply_to_review(int review_id, const String& text);
};

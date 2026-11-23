#pragma once
#include "User.h"

class Buyer : public User
{
public:
    void add_to_cart(int product_id, int quantity);
    bool place_order();
    bool submit_review(int product_id, int rating, const String& text);
};

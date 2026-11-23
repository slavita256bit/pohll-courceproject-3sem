#pragma once
#include "String.h"

class Review
{
private:
    int id = 0;
    int product_id = 0;
    int buyer_id = 0;
    int rating = 0;
    String text;
    bool has_reply = false;
    String reply;
};

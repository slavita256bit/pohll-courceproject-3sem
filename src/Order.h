#pragma once
#include "String.h"
#include "OrderItem.h"
#include <vector>

enum class OrderStatus
{
    Pending,
    Sent
};

class Order
{
private:
    int id = 0;
    int buyer_id = 0;
    String delivery_address;
    OrderStatus status = OrderStatus::Pending;
    std::vector<OrderItem> items;

public:
    void confirm();
};

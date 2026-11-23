#pragma once
#include "Account.h"

class User : public Account
{
private:
    String name;
    String phone;
    String address;

public:
    const String& get_name() const;
    const String& get_phone() const;
    const String& get_address() const;
};

#pragma once
#include "String.h"

class Account
{
private:
    int id = 0;
    String login;
    String password_hash;

public:
    virtual ~Account() = default;

    int get_id() const;
    bool check_password(const String& password) const;
};

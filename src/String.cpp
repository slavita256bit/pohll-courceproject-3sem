#include "String.h"
#include <algorithm>
#include <iterator>

// Выделение памяти под строку длины new_length
void String::allocate(int new_length)
{
    this->length = new_length;
    this->data = new char[this->length + 1]{};
}

bool String::is_a(char c)
{
    return c == 'a';
}

bool String::is_z(char c)
{
    return c == 'z';
}

// Оператор присваивания
String& String::operator=(const String& other)
{
    if (this != &other)
    {
        char* new_data = new char[other.length + 1]{};
        if (other.length > 0)
            std::copy_n(other.data, other.length, new_data);
        delete[] this->data;
        this->data = new_data;
        this->length = other.length;
    }

    return *this;
}

// Удаление всех вхождений other из строки
String String::operator-(const String& other) const
{
    if (this->length == 0 || other.length == 0)
        return *this;

    const char* text_end = this->data + this->length;
    const char* pattern_begin = other.data;
    const char* pattern_end = other.data + other.length;

    String result(this->length);
    char* result_end = result.data;

    const char* current = this->data;
    const char* match;
    do
    {
        match = std::search(current, text_end, pattern_begin, pattern_end);
        result_end = std::copy(current, match, result_end);
        if (match != text_end)
            current = match + other.length;
    }
    while (match != text_end);
    *result_end = '\0';

    result.length = static_cast<int>(result_end - result.data);
    return result;
}

// Добавление other к строке
String& String::operator+=(const String& other)
{
    int new_length = this->length + other.length;
    char* new_data = new char[new_length + 1]{};

    if (this->length > 0)
        std::copy_n(this->data, this->length, new_data);
    if (other.length > 0)
        std::copy_n(other.data, other.length, new_data + this->length);

    delete[] this->data;
    this->data = new_data;
    this->length = new_length;

    return *this;
}

// Увеличение последнего символа
String& String::operator++()
{
    if (this->length == 0)
        return *this;

    std::reverse_iterator<char*> rbegin(this->data + this->length);
    std::reverse_iterator<char*> rend(this->data);

    auto it = std::find_if_not(rbegin, rend, is_z);
    std::fill(rbegin, it, 'a');

    if (it != rend)
        ++(*it);

    return *this;
}

String String::operator++(int)
{
    String old(*this);
    ++(*this);
    return old;
}

// Уменьшение последнего символа
String& String::operator--()
{
    if (this->length == 0)
        return *this;

    std::reverse_iterator<char*> rbegin(this->data + this->length);
    std::reverse_iterator<char*> rend(this->data);

    auto it = std::find_if_not(rbegin, rend, is_a);
    std::fill(rbegin, it, 'z');

    if (it != rend)
        --(*it);

    return *this;
}

String String::operator--(int)
{
    String old(*this);
    --(*this);
    return old;
}

// Получение символа по индексу
char& String::operator[](int i)
{
    return this->data[i];
}

// Получение подстроки длины count с индекса from
String String::operator()(int from, int count) const
{
    String result(count);
    if (count > 0)
        std::copy_n(this->data + from, count, result.data);
    result.data[count] = '\0';
    return result;
}

// Сложение строк
String operator+(const String& a, const String& b)
{
    String result(a);
    result += b;
    return result;
}

String operator+(const String& a, const char* b)
{
    return a + String(b);
}

String operator+(const char* a, const String& b)
{
    return String(a) + b;
}

// Равенство строк
bool operator==(const String& a, const String& b)
{
    return a.length == b.length && (a.length == 0 || std::equal(a.data, a.data + a.length, b.data));
}

// Неравенство строк
bool operator!=(const String& a, const String& b)
{
    return !(a == b);
}

// Сравнение строк
bool operator<(const String& a, const String& b)
{
    if (a.length == 0 || b.length == 0)
        return a.length < b.length;

    return std::lexicographical_compare(a.data, a.data + a.length, b.data, b.data + b.length);
}

bool operator>(const String& a, const String& b)
{
    return b < a;
}

bool operator<=(const String& a, const String& b)
{
    return !(a > b);
}

bool operator>=(const String& a, const String& b)
{
    return !(a < b);
}

// Ввод строки
std::istream& operator>>(std::istream& stream, String& s)
{
    char buffer[MAX_LENGTH + 1]{};
    stream >> buffer;

    s = String(buffer);

    return stream;
}

// Вывод строки
std::ostream& operator<<(std::ostream& stream, const String& s)
{
    stream << (s.data ? s.data : "");

    return stream;
}

// Форматирование строки
std::format_context::iterator std::formatter<String>::format(const String& value, std::format_context& ctx) const
{
    return std::formatter<std::string_view>::format(std::string_view(value.data ? value.data : ""), ctx);
}

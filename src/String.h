#pragma once
#include <iostream>
#include <algorithm>
#include <utility>
#include <format>
#include <string_view>

/*
Лабораторная работа 2 | Перегрузка операций

Реализовать класс String для работы со строками символов

конструктор без параметров
конструктор с параметрами
конструктор копирования

Перегрузить операции:
оператор присваивания
+ конкатенация строк (3 перегрузки: String+String, String + const char*, const char* + String)
- вычитание строк
+= добавление к строке строки
++ увеличение последнего символа
-- уменьшение последнего символа
<
>
>=
<=
[] взятие индекса class method
()(int, int) выделение подстроки из строки
<< >> перегрузка ввода/вывода

Пример: d = "БГУИР" + a + b + c + "ФКСИС", где a, b, c - объекты String
=> отдельно const + объект, объект + const и объект + объект
*/

#define MAX_LENGTH 80

class String
{
private:
    int length = 0;                              // Длина строки
    char* data = nullptr;                        // Массив символов

    void allocate(int new_length);               // Выделение памяти под строку длины new_length

    static bool is_a(char c);                    // Проверка символа на 'a' (для переноса в operator--)
    static bool is_z(char c);                    // Проверка символа на 'z' (для переноса в operator++)

public:
    String() : String("") {}
    explicit String(const char* str)
    {
        auto new_length = static_cast<int>(std::char_traits<char>::length(str ? str : ""));

        allocate(new_length);
        if (new_length > 0)
            std::copy_n(str, new_length, this->data);
    }

    explicit String(int new_length)                                                                 // Конструктор пустой строки заданной длины
    {
        allocate(new_length);
    }

    String(const String& copy) : String(copy.data) {}                                               // Конструктор копирования
    String(String&& other) noexcept                                                                 // Конструктор перемещения
        : length(std::exchange(other.length, 0)), data(std::exchange(other.data, nullptr)) {}

    String& operator=(const String& other);                                                         // Оператор присваивания

    String operator-(const String& other) const;                                                    // Удаление всех вхождений other из строки
    String& operator+=(const String& other);                                                        // Добавление other к строке

    String& operator++();                                                                           // Увеличение последнего символа
    String operator++(int);                                                                         // Увеличение последнего символа
    String& operator--();                                                                           // Уменьшение последнего символа
    String operator--(int);                                                                         // Уменьшение последнего символа

    char& operator[](int i);                                                                        // Получение символа по индексу
    String operator()(int from, int count) const;                                                   // Получение подстроки длины count с индекса from

    ~String()                                                                                       // Освобождение массива символов
    {
        delete[] this->data;
    }

    friend String operator+(const String& a, const String& b);                                      // Сложение строк
    friend String operator+(const String& a, const char* b);                                        // Сложение строк
    friend String operator+(const char* a, const String& b);                                        // Сложение строк

    friend bool operator==(const String& a, const String& b);                                       // Равенство строк
    friend bool operator!=(const String& a, const String& b);                                       // Неравенство строк
    friend bool operator<(const String& a, const String& b);                                        // Сравнение строк
    friend bool operator>(const String& a, const String& b);                                        // Сравнение строк
    friend bool operator<=(const String& a, const String& b);                                       // Сравнение строк
    friend bool operator>=(const String& a, const String& b);                                       // Сравнение строк

    friend std::istream& operator>>(std::istream& stream, String& s);                               // Ввод строки
    friend std::ostream& operator<<(std::ostream& stream, const String& s);                         // Вывод строки

    friend struct std::formatter<String>;                                                           // Доступ форматтера к строке
};

template<>
struct std::formatter<String> : std::formatter<std::string_view>
{
    std::format_context::iterator format(const String& value, std::format_context& ctx) const;      // Форматирование строки
};

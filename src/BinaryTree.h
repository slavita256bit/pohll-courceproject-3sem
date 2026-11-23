#pragma once
/*
Лабораторная работа 4 | Шаблоны | Бинарное дерево

...

Итераторы
*/
#include <ostream>
#include <functional>
#include <utility>
#include "BinaryTreeIterator.h"

template<typename T>
class BinaryTree;

template<typename T>
std::ostream& operator<<(std::ostream& stream, const BinaryTree<T>& tree);        // Вывод таблицы класса

template<typename T>
class BinaryTree
{
public:
    using Compare = std::function<bool(const T&, const T&)>;

private:
    Compare compare;
    bool precedes(const T& a, const T& b) const;

    T* value = nullptr;                                          // Объект, принадлежащий дереву
    BinaryTree* left = nullptr;                                  // Левое поддерево
    BinaryTree* right = nullptr;                                 // Правое поддерево

    static bool has_child(const BinaryTree* child);              // Проверка непустого потомка

    T* extract();                                                // Извлечение объекта текущего узла
    void swap(BinaryTree& other) noexcept;                       // Поменять дваподдерева местами
    BinaryTree* find_smallest();                                 // Поиск наименьшего узла

public:
    BinaryTree() = default;                               // Создание пустого дерева
    explicit BinaryTree(Compare compare) : compare(std::move(compare)) {}
    explicit BinaryTree(T* object) : value(object) {}     // Создание дерева с одним объектом

    ~BinaryTree()                                         // Очистка дерева
    {
        clear();
    }

    BinaryTree(const BinaryTree&) = delete;
    BinaryTree& operator=(const BinaryTree&) = delete;

    bool empty() const;                                  // Проверка пустого дерева
    int size() const;                                    // Получение количества объектов
    void add(T* object);                                 // Добавление с передачей владения
    T operator[](int number);                            // Копирование объекта по номеру строки
    bool remove();                                       // Удаление элемента текущего узла
    BinaryTree* find(const T& object);                   // Поиск объекта по всем полям
    void clear();                                        // Удаление объектов и поддеревьев
    void print_header(std::ostream& stream) const;       // Вывод шапки таблицы

    friend std::generator<const T&> iterate<T>(const BinaryTree& tree);                // Обход по порядку ключа
    friend std::ostream& operator<< <T>(std::ostream& stream, const BinaryTree& tree); // Вывод таблицы класса
};

#include "BinaryTree.tpp"

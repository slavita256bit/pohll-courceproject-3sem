#pragma once
#include <generator>

template<typename T>
class BinaryTree;

template<typename T>
std::generator<const T&> iterate(const BinaryTree<T>& tree);          // Обход по порядку ключа

#include "BinaryTreeIterator.tpp"

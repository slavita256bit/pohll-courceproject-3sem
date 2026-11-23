#pragma once
#include "File.h"
#include <vector>

template<class T>
class TextFile : public File
{
public:
    explicit TextFile(std::filesystem::path path) : File(std::move(path), {}) {}

    std::vector<T> load() const
    {
        auto stream = open(std::ios::in);
        std::vector<T> records;
        while ((stream >> std::ws).peek() != std::char_traits<char>::eof())
        {
            T record{};
            if (!(stream >> record))
                throw std::runtime_error("Не удалось прочитать текстовую запись");
            records.push_back(std::move(record));
        }
        if (stream.bad() || !stream.eof())
            throw std::runtime_error("Ошибка чтения файла");
        return records;
    }

    void save(const std::vector<T>& records) const
    {
        auto stream = open(std::ios::out | std::ios::trunc);
        for (const auto& record : records)
            stream << record << '\n';
        stream.close();
        if (!stream)
            throw std::runtime_error("Не удалось сохранить текстовый файл");
    }
};

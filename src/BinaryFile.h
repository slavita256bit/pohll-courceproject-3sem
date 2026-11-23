#pragma once
#include "File.h"
#include <vector>

template<class T>
class BinaryFile : public File
{
public:
    explicit BinaryFile(std::filesystem::path path) : File(std::move(path), std::ios::binary) {}

    std::vector<T> load() const
    {
        auto stream = open(std::ios::in);
        std::vector<T> records;
        while (stream.peek() != std::char_traits<char>::eof())
        {
            T record{};
            record.read_binary(stream);
            if (!stream)
                throw std::runtime_error("Не удалось прочитать бинарную запись");
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
            record.write_binary(stream);
        stream.close();
        if (!stream)
            throw std::runtime_error("Не удалось сохранить бинарный файл");
    }
};

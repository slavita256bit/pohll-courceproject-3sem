#pragma once
#include <filesystem>
#include <fstream>
#include <stdexcept>
#include <utility>

class File
{
private:
    std::filesystem::path path;
    std::ios::openmode mode;

protected:
    File(std::filesystem::path path, std::ios::openmode mode)
        : path(std::move(path)), mode(mode) {}

    std::fstream open(std::ios::openmode access) const
    {
        std::fstream stream(path, mode | access);
        if (!stream)
            throw std::runtime_error("Не удалось открыть файл");
        return stream;
    }

public:
    virtual ~File() = default;
    const std::filesystem::path& get_path() const { return path; }
};

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <list>
#include <stack>

struct Movement
{
    size_t count;
    size_t from;
    size_t to;
};

using Stack = std::list<char>;
using Stacks = std::vector<Stack>;
using Movements = std::vector<Movement>;

std::tuple<Stacks, Movements>
load_data(const std::string&);

Stacks
run(Stacks, const Movements&, bool);

int
main()
{
    const auto [stacks, movements] = load_data("input.txt");
    const auto result_stacks_simple = run(stacks, movements, false);
    const auto result_stacks_advanced = run(stacks, movements, true);

    auto result_simple = std::string{};
    for (const auto& stack : result_stacks_simple) {
        result_simple += stack.back();
    }

    auto result_advanced = std::string{};
    for (const auto& stack : result_stacks_advanced) {
        result_advanced += stack.back();
    }

    std::cout << "Top crates simple  : " << result_simple << std::endl;
    std::cout << "Top crates advanced: " << result_advanced << std::endl;
}

std::tuple<Stacks, Movements>
load_data(const std::string& file_path)
{
    auto file = std::ifstream{file_path};
    if (file.bad()) {
      std::cerr << "Unable to open input file: " << file_path
                << std::endl;
    }

    std::string line;
    std::getline(file, line);
    const auto size = line.size() / 4 + 1;

    auto stacks = std::vector<std::list<char>>{size, std::list<char>{}};

    do {
        if (line.empty()) {
            break;
        }

        for (size_t i = 1; i < line.size(); i += 4) {
            const auto c = line[i];
            if (c == '1') {
                break;
            }

            if (c != ' ') {
                stacks[i / 4].push_front(c);
            }
        }
    } while (std::getline(file, line));

    auto movements = Movements{};
    std::string tmp;
    while (!file.eof()) {
        auto movement = Movement{};
        file >> tmp
             >> movement.count
             >> tmp
             >> movement.from
             >> tmp
             >> movement.to;
        movement.from -= 1;
        movement.to -= 1;
        movements.push_back(movement);
    }

    return {stacks, movements};
}

Stacks
run(Stacks stacks, const Movements& movements, bool advanced_crate)
{
    for (const auto movement : movements) {
        if (advanced_crate) {
            auto stack = std::stack<char>{};
            for (size_t i = 0; i < movement.count; ++i) {
                stack.push(stacks[movement.from].back());
                stacks[movement.from].pop_back();
            }

            while (!stack.empty()) {
                stacks[movement.to].push_back(stack.top());
                stack.pop();
            }
        } else {
            for (size_t i = 0; i < movement.count; ++i) {
                stacks[movement.to].push_back(stacks[movement.from].back());
                stacks[movement.from].pop_back();
            }
        }
    }

    return stacks;
}

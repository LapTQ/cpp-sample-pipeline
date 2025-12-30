#ifndef CONFIG_H
#define CONFIG_H

#include <string>

namespace app {

struct Config {
    // Always provide default values for your members
    std::string video_path{};
    std::string model_path{};

    // When adding a new member variable to a struct, put it at the end to avoid breaking existing code
};

}  // namespace app

#endif  // CONFIG_H
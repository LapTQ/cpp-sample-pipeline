cmake_minimum_required(VERSION 3.10)
project(cpp_sample_pipeline)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)   # Tạo file compile_commands.json => clangd

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Chỉ định nơi tìm OpenCV
set(OpenCV_DIR "/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib/cmake/opencv4")

find_package(OpenCV REQUIRED)

add_executable(main apps/main.cpp)
target_link_libraries(main ${OpenCV_LIBS})
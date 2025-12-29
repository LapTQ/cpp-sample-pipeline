# cmake_minimum_required(VERSION 3.5)
# project(d2)

# # Chỉ định nơi tìm OpenCV
# set(OpenCV_DIR "/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib/cmake/opencv4")

# find_package(OpenCV REQUIRED)

# add_executable(d2 d2.cpp)
# target_link_libraries(d2 ${OpenCV_LIBS})


cmake_minimum_required(VERSION 3.5)
project( d2 )
find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )
add_executable( d2 d2.cpp )
target_link_libraries( d2 ${OpenCV_LIBS} )
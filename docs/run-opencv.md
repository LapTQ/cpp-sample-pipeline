

## 

Compile:

```bash
g++ d2.cpp -o d2 \
  -I./libs/opencv/latest/install/include/opencv4 \
  -L./libs/opencv/latest/install/lib \
  -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_videoio -lopencv_imgcodecs \
  -std=c++17 \
```

Run:

```bash
# Trên macOS, biến môi trường là DYLD_LIBRARY_PATH chứ KHÔNG phải LD_LIBRARY_PATH (của Linux)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib

./d2
```


## Dùng CMake

Hoặc:

```
cmake_minimum_required(VERSION 3.5)
project(d2)

# Chỉ định nơi tìm OpenCV
set(OpenCV_DIR "/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib/cmake/opencv4")

find_package(OpenCV REQUIRED)

add_executable(d2 d2.cpp)
target_link_libraries(d2 ${OpenCV_LIBS})
```

Build:

```bash
cmake
make
```

Hoặc:
```
cmake_minimum_required(VERSION 3.5)
project( d2 )
find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )
add_executable( d2 d2.cpp )
target_link_libraries( d2 ${OpenCV_LIBS} )
```

Build:
```bash
cmake . -D OpenCV_DIR=/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib/cmake/opencv4
make
```
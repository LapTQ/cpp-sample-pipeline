cmake_minimum_required(VERSION 3.10)
project(cpp_sample_pipeline)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)   # Tạo file compile_commands.json => clangd

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- Chỉ định nơi tìm OpenCV ---
set(OpenCV_DIR "/Users/user/Downloads/cpp-sample-pipeline/libs/opencv/latest/install/lib/cmake/opencv4")
find_package(OpenCV REQUIRED)

# --- Setup ONNX Runtime ---
set(ONNX_ROOT "/Users/user/Downloads/cpp-sample-pipeline/libs/onnxruntime/1.23.2") # Đường dẫn tới folder giải nén
include_directories(${ONNX_ROOT}/include)
link_directories(${ONNX_ROOT}/lib)


# --- 1. SETUP YOLO MODULE ---
# Định nghĩa đường dẫn tới source code YOLO bạn vừa tải
set(YOLO_SOURCE_DIR /Users/user/Downloads/cpp-sample-pipeline/libs/yolov8onnx/latest/source)

# Tạo một thư viện tĩnh (Static Library) tên là "yolo_lib"
# CHÚ Ý: Chỉ lấy inference.cpp, TUYỆT ĐỐI KHÔNG lấy main.cpp
add_library(yolo_lib STATIC "${YOLO_SOURCE_DIR}/inference.cpp")

# Chỉ định thư mục chứa header (inference.h) để main app có thể #include
target_include_directories(yolo_lib PUBLIC "${YOLO_SOURCE_DIR}")

# Yolo lib cần OpenCV và ONNX Runtime để hoạt động, nên phải link cho nó
target_link_libraries(yolo_lib 
    PUBLIC 
    ${OpenCV_LIBS} 
    onnxruntime # Link file libonnxruntime.dylib
)
# Nếu bạn setup ONNX Runtime thủ công (manual path), nhớ add include directories cho yolo_lib:
target_include_directories(yolo_lib PRIVATE "${ONNX_ROOT}/include")


# --- 2. MAIN APP ---
# 1. Định nghĩa executable từ file main.cpp
# LƯU Ý: Nếu Config.h có file Config.cpp đi kèm, bạn phải liệt kê cả nó vào đây
# Ví dụ: add_executable(main apps/main.cpp src/Config.cpp)
add_executable(run_detection apps/run_detection.cpp src/Loader.cpp)

# 2. [QUAN TRỌNG] Chỉ định thư mục chứa header
# Lệnh này bảo CMake: "Khi biên dịch 'main', hãy tìm header trong thư mục 'include' nữa"
target_include_directories(
    run_detection 
    PRIVATE 
    include
)


target_link_libraries(
    run_detection 
    PRIVATE 
    yolo_lib    # Link module yolo vào app chính
    ${OpenCV_LIBS}
    onnxruntime  # Link file libonnxruntime.dylib. (Không cần link lại nếu yolo_lib đã link PUBLIC)
)
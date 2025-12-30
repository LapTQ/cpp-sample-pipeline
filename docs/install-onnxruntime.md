Để tích hợp ONNX Runtime (ORT) vào project C++ hiện tại của bạn để xử lý frame từ `Loader`, chúng ta sẽ đi qua 2 phần: **Cài đặt** và **Quy trình code**.

Dựa vào đường dẫn file `/Users/user/...` trong câu hỏi trước, mình đoán bạn đang dùng **macOS**.

---

### Phần 1: Cài đặt ONNX Runtime (CPU)

Có 2 cách phổ biến nhất. Với project C++ cá nhân, mình khuyên dùng **Cách 2 (Pre-built binaries)** để dễ quản lý thư mục `libs` như bạn đã làm với OpenCV, hoặc **Cách 1 (Homebrew)** nếu muốn nhanh gọn lẹ.

#### Cách 1: Dùng Homebrew (Nhanh nhất trên macOS)

Đây là cách dễ nhất, không cần lo tải file thủ công.

1. Mở terminal chạy:
```bash
brew install onnxruntime

```


2. File thư viện sẽ nằm ở `/opt/homebrew/lib` và header ở `/opt/homebrew/include`.

#### Cách 2: Tải Pre-built Binaries (Khuyên dùng để project độc lập)

Cách này giúp project của bạn mang sang máy khác vẫn build được, giống cấu trúc `libs/` bạn đang có.

1. Vào [GitHub Releases của ONNX Runtime](https://github.com/microsoft/onnxruntime/releases).
2. Tìm bản mới nhất (ví dụ 1.16.x hoặc 1.17.x).
3. Tải file nén cho macOS: `onnxruntime-osx-universal2-x.x.x.tgz`.
4. Giải nén và đặt vào thư mục `libs` của dự án. Cấu trúc sẽ trông như sau:
```text
cpp_sample_pipeline/
├── libs/
│   ├── opencv/
│   └── onnxruntime/    <-- Thư mục giải nén
│       ├── include/
│       └── lib/

```



---

### Phần 2: Cấu hình CMake

Dưới đây là cách sửa `CMakeLists.txt` để link ONNX Runtime (giả sử bạn chọn **Cách 2** - để trong `libs`).

```cmake
# ... (Phần OpenCV cũ giữ nguyên)

# 1. Setup ONNX Runtime
set(ONNX_ROOT "${CMAKE_SOURCE_DIR}/libs/onnxruntime") # Đường dẫn tới folder giải nén

include_directories(${ONNX_ROOT}/include)
link_directories(${ONNX_ROOT}/lib)

# 2. Add Executable
add_executable(main apps/main.cpp src/Detector.cpp) # Giả sử bạn tạo thêm class Detector

# 3. Link thư viện
# Tên thư viện onnxruntime có thể khác nhau tùy phiên bản tải về (ví dụ onnxruntime.1.16.0)
# Bạn vào folder libs/onnxruntime/lib check tên chính xác nhé.
target_link_libraries(main 
    PRIVATE 
    ${OpenCV_LIBS} 
    onnxruntime # Link file libonnxruntime.dylib
)

```

*(Nếu dùng Homebrew, bạn thay `ONNX_ROOT` bằng `/opt/homebrew`)*

---

### Phần 3: Các bước Code để Infer (Suy luận)

Quy trình chuẩn khi dùng ONNX Runtime với OpenCV:

1. **Khởi tạo Env & Session:** Chỉ làm 1 lần khi khởi tạo class (trong Constructor).
2. **Pre-processing (Quan trọng nhất):**
* Model ONNX thường nhận input dạng `NCHW` (Batch, Channels, Height, Width) và hệ màu `RGB`, giá trị `float32` (đã chuẩn hóa 0-1).
* Trong khi OpenCV `cv::Mat` là `HWC`, `BGR`, `uint8` (0-255).
* => Cần bước chuyển đổi.


3. **Run Inference:** Đẩy data vào và nhận kết quả.
4. **Post-processing:** Parse output tensor thành tọa độ (bounding box), class id.


## Tôi chưa hiểu dòng `onnxruntime # Link file libonnxruntime.dylib`. Hai cái tên không giống nhau thì làm sao nó hiểu được?

Đây là một câu hỏi rất hay về cơ chế hoạt động bên dưới của C/C++ mà người mới thường thắc mắc.

Câu trả lời ngắn gọn: **Đây là quy ước "bất thành văn" (Standard Convention) của trình biên dịch (GCC/Clang) mà CMake tuân theo.**

Khi bạn viết `onnxruntime` trong CMake, nó không đi tìm file tên là `onnxruntime`. Nó sẽ tự động "lắp ghép" thêm đầu và đuôi để tạo thành tên file đầy đủ.

Dưới đây là cơ chế chi tiết:

### 1. Quy tắc "Bánh mì kẹp thịt" (Prefix & Extension)

Trình liên kết (Linker) trên các hệ điều hành Unix (Linux/macOS) luôn tuân thủ quy tắc tìm kiếm file thư viện như sau:

* **Đầu (Prefix):** Luôn tự động thêm chữ **`lib`** vào trước tên.
* **Đuôi (Extension):** Luôn tự động thêm đuôi **`.dylib`** (trên macOS) hoặc **`.so`** (trên Linux).

**Ví dụ minh họa:**

| Tên bạn viết trong CMake | Tên file thực tế Linker sẽ đi tìm |
| --- | --- |
| `onnxruntime` | **lib**`onnxruntime`**.dylib** |
| `opencv_core` | **lib**`opencv_core`**.dylib** |
| `my_custom_lib` | **lib**`my_custom_lib`**.dylib** |

### 2. CMake thực sự làm gì?

Khi bạn viết:

```cmake
target_link_libraries(main PRIVATE onnxruntime)

```

CMake sẽ dịch dòng này thành câu lệnh Terminal cho trình biên dịch (Clang/G++) như sau:

```bash
# Lệnh thực tế chạy ngầm
g++ ... -L/path/to/libs -lonnxruntime

```

* `-L`: Chỉ định thư mục tìm kiếm (nhờ lệnh `link_directories` bạn đã khai báo).
* `-l` (L viết thường): Viết tắt của "link library". Khi gặp cờ `-l` này, trình biên dịch sẽ áp dụng quy tắc ở **Mục 1**: Lấy chuỗi phía sau (`onnxruntime`), ghép thêm `lib` và `.dylib` rồi tìm trong thư mục `-L`.

### 3. Điều kiện bắt buộc để "phép màu" này xảy ra

Để CMake (và Linker) hiểu được `onnxruntime` chính là file nằm trong folder `libs`, bạn bắt buộc phải có dòng lệnh chỉ đường trước đó:

```cmake
# Dòng này cực kỳ quan trọng, nếu thiếu Linker sẽ không biết tìm ở đâu
link_directories(${CMAKE_SOURCE_DIR}/libs/onnxruntime/lib) 

```

### Tóm tắt

Bạn viết `onnxruntime` vì đó là **tên định danh** của thư viện. Hệ thống sẽ tự hiểu file vật lý tương ứng là `libonnxruntime.dylib`.

* Nếu file của bạn tên là `onnxruntime.dylib` (thiếu chữ `lib` ở đầu) -> Linker sẽ **báo lỗi** không tìm thấy.
* File bắt buộc phải tên là `libonnxruntime.dylib` thì lệnh `-lonnxruntime` mới hoạt động.
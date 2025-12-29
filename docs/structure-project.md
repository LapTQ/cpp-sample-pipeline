Việc tổ chức thư mục khi làm việc với các thư viện build từ source (như OpenCV, FFmpeg, TensorRT...) là cực kỳ quan trọng. Nếu không quy hoạch rõ ràng, sau này bạn sẽ rất khó update phiên bản, khó xóa sạch (uninstall) hoặc khó quản lý xung đột giữa các project.

Dưới đây là cấu trúc thư mục tiêu chuẩn mà các lập trình viên C++ thường dùng để quản lý thư viện ("Library Workspace").

# 1. Cấu trúc cây thư mục đề xuất

Tôi khuyên bạn nên tạo một thư mục gốc tên là `libs` (hoặc `3rdparty`, `workspace`) tại thư mục Home của bạn. Trong đó, mỗi thư viện sẽ có không gian riêng được chia làm 3 phần: **Source**, **Build**, và **Install**.

```text
/home/username/libs/
│
├── opencv/                     <-- Tên thư viện
│   ├── 4.10.0/                 <-- Phiên bản (Quan trọng để quản lý nhiều version)
│   │   ├── source/             <-- Chứa code tải từ Git
│   │   ├── build/              <-- Chứa file tạm khi chạy make (có thể xóa đi build lại)
│   │   └── install/            <-- KẾT QUẢ CUỐI CÙNG (Headers + Libs)
│   │
│   └── 3.4.16/                 <-- Ví dụ bạn cần cả bản cũ
│       ├── source/
│       ├── build/
│       └── install/
│
├── ffmpeg/
│   └── ...
│
└── ...

```

Ý nghĩa từng thư mục:

1. **`source`**: Đây là nơi bạn `git clone`. Thư mục này nên giữ "sạch" (pristine), không chứa file rác của quá trình build.
2. **`build`**: Đây là nơi bạn đứng để gõ lệnh `cmake` và `make`. Nếu quá trình build bị lỗi hoặc bạn muốn đổi cấu hình (ví dụ tắt Python support), bạn chỉ cần `rm -rf build` và tạo lại thư mục build mới mà không ảnh hưởng đến source code.
3. **`install`**: Đây là **quan trọng nhất**. Thay vì cài vào hệ thống (`/usr/local`), ta sẽ cài vào thư mục này.
* Nó sẽ chứa: `include/`, `lib/`, `bin/`, `share/`.
* Lợi ích: Khi bạn muốn xóa thư viện? Chỉ cần xóa thư mục này. Khi bạn muốn copy thư viện sang máy khác? Chỉ cần copy thư mục này.

## 2. Gom theo Thư viện (Library-Centric) vs Gom theo Chức năng (Function-Centric)

Đối với một **Developer** (người phát triển phần mềm) cần quản lý nhiều thư viện với nhiều phiên bản, cách tổ chức **"Gom theo Thư viện" (Cách 1)** sẽ vượt trội hơn cách **"Gom theo Chức năng" (Cách 2)**.

Hãy cùng phân tích chi tiết ưu/nhược điểm để bạn thấy rõ tại sao.

### 1. So sánh trực quan

#### Cách 1: Gom theo Thư viện (Library-Centric)

Mỗi thư viện là một "vương quốc" riêng.

```text
libs/
├── opencv/
│   ├── source/
│   ├── build/
│   └── install/
├── ffmpeg/
│   ├── source/
│   ├── build/
│   └── install/

```

#### Cách 2: Gom theo Chức năng (Function-Centric)

Tất cả mã nguồn ở một nơi, tất cả file cài đặt ở một nơi.

```text
libs/
├── source/
│   ├── opencv/
│   └── ffmpeg/
├── build/
│   ├── opencv/
│   └── ffmpeg/
├── install/
│   ├── opencv/    <-- (Hoặc gộp chung bin/lib tại đây)
│   └── ffmpeg/

```

---

### 2. Tại sao Cách 1 (Gom theo Thư viện) lại tốt hơn?

Trong quản lý dự án, người ta ưu tiên tính **"Cô lập" (Isolation)** và **"Nguyên tử" (Atomic)**.

#### a. Dễ dàng xóa bỏ (Uninstall/Clean up)

* **Cách 1:** Bạn chán OpenCV? Bạn build sai? Bạn chỉ cần chạy **1 lệnh duy nhất**: `rm -rf libs/opencv`. Toàn bộ dấu vết (code, file rác, file thư viện) biến mất sạch sẽ.
* **Cách 2:** Bạn phải vào `libs/source` xóa thư mục opencv, rồi nhớ sang `libs/build` xóa tiếp, rồi sang `libs/install` xóa tiếp. Nếu quên xóa ở `install`, file rác vẫn nằm đó, gây tốn dung lượng hoặc xung đột sau này.

#### b. Quản lý phiên bản (Versioning)

Đây là "nỗi đau" lớn nhất của dân lập trình C/C++.

* **Cách 1:** Bạn dễ dàng có cấu trúc:
* `libs/opencv/4.10.0/...`
* `libs/opencv/3.4.16/...`
Mọi thứ của bản 4.10 nằm gọn trong thư mục của nó, không bao giờ "đá" nhau với bản 3.4.


* **Cách 2:** Nếu bạn dùng thư mục `libs/install` chung cho tất cả, file `libopencv_core.so` của bản mới có thể ghi đè bản cũ, hoặc tạo ra một mớ hỗn độn các file version trong cùng một thư mục `lib`.

#### c. Context Switching (Chuyển đổi ngữ cảnh)

Khi bạn đang làm việc với OpenCV, bạn thường cần xem cả code gốc (để hiểu hàm hoạt động thế nào) và xem file build (để check lỗi).

* **Cách 1:** Mọi thứ nằm cạnh nhau. Bạn `cd` vào `libs/opencv` là có đủ đồ chơi.
* **Cách 2:** Bạn phải `cd` qua lại giữa các thư mục nằm rất xa nhau trong cây thư mục.

---

### 3. Khi nào thì Cách 2 (Gom theo Chức năng) hữu dụng?

Cách 2 không phải là sai, nó thực chất là mô phỏng cấu trúc của hệ điều hành Linux (`/usr/src`, `/usr/bin`, `/usr/lib`).

Cách này hữu dụng **DUY NHẤT** ở thư mục `install` nếu bạn muốn tạo ra một môi trường **"Global Environment"** cho riêng mình (giống như Conda environment hay Virtualenv của Python).

**Ưu điểm duy nhất của Cách 2:**
Nếu bạn gộp tất cả output vào chung một thư mục `libs/install` (tức là trong đó có 1 folder `bin`, 1 folder `lib` chứa hổ lốn cả OpenCV, FFmpeg, v.v.), bạn chỉ cần setup biến môi trường **MỘT LẦN**:

```bash
# Chỉ cần export 1 lần cho tất cả thư viện
export LD_LIBRARY_PATH=~/libs/install/lib:$LD_LIBRARY_PATH

```

Tuy nhiên, cái giá phải trả là **Rủi ro xung đột cao** (Dependency Hell). Nếu thư viện A cần `libjpeg` bản cũ, thư viện B cần `libjpeg` bản mới, việc cài chung vào một chỗ sẽ khiến một trong hai thư viện bị lỗi (crash).


## 3. Cách thực hiện với OpenCV

Dựa trên cấu trúc "Gom theo Thư viện", quy trình cài đặt OpenCV của bạn sẽ thay đổi một chút ở bước CMake (bước quan trọng nhất là cờ `-DCMAKE_INSTALL_PREFIX`).

**Bước 1: Tạo cấu trúc thư mục**

```bash
mkdir -p ~/libs/opencv/4.10.0
cd ~/libs/opencv/4.10.0

```

**Bước 2: Tải source**

```bash
git clone https://github.com/opencv/opencv.git source
# (Optional) Checkout đúng tag version
cd source && git checkout 4.10.0 && cd ..

```

**Bước 3: Build và trỏ thư mục Install**

```bash
mkdir build && cd build

# LỆNH QUAN TRỌNG: Cờ CMAKE_INSTALL_PREFIX
cmake -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=~/libs/opencv/4.10.0/install \
      ../source

make -j4
make install

```

*Lưu ý: Lúc này bạn không cần `sudo make install` nữa vì bạn đang cài vào thư mục home của chính mình.*

### 4. Cách sử dụng thư viện sau khi cài theo cấu trúc này

Vì ta không cài vào thư mục chuẩn của hệ thống (`/usr/local`), nên khi code, bạn cần chỉ cho CMake biết thư viện nằm ở đâu.

**Trong file `CMakeLists.txt` của dự án:**

```cmake
cmake_minimum_required(VERSION 3.0)
project(MyApp)

# Chỉ định nơi tìm OpenCV
set(OpenCV_DIR "/home/username/libs/opencv/4.10.0/install/lib/cmake/opencv4")

find_package(OpenCV REQUIRED)

add_executable(my_app main.cpp)
target_link_libraries(my_app ${OpenCV_LIBS})

```

**Lợi ích của cách làm này:**

1. **Sạch sẽ:** Không làm rác thư mục hệ thống `/usr`.
2. **Đa phiên bản:** Bạn có thể có `opencv/4.10.0` và `opencv/3.4` song song. Dự án A dùng bản 4, dự án B dùng bản 3 chỉ bằng cách đổi đường dẫn `OpenCV_DIR`.
3. **Dễ sửa lỗi:** Nếu build sai, chỉ cần xóa thư mục `install` và `build` làm lại, không sợ ảnh hưởng các thư viện khác.

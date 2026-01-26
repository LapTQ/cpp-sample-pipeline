# Building and Installing OpenCV from Source

## Quick Installation Script

Below is the complete sequence of commands to download, build, and install OpenCV:

```bash
# 1. Update system and install dependencies
sudo apt update
sudo apt install -y g++ cmake make git libgtk2.0-dev pkg-config

# 2. Clone the repository
git clone https://github.com/opencv/opencv.git

# 3. Create build directory
mkdir -p build && cd build

# 4. Generate build scripts
cmake ../opencv

# 5. Compile the source code
make -j4

# 6. Install to system
sudo make install

```

---

## Step-by-Step Explanation

### 1. Preparation

First, install the necessary compilers and libraries:

```bash
sudo apt update
sudo apt install -y g++ cmake make git libgtk2.0-dev pkg-config

```

Download the OpenCV source code:

```bash
git clone https://github.com/opencv/opencv.git

```

Create a dedicated build directory to keep the source tree clean, then navigate into it:

```bash
mkdir -p build && cd build

```

Generate the build configuration and Makefiles using CMake:

```bash
cmake ../opencv

```

Next, we proceed with two distinct stages:

1. **Building the software** (compiling the source code).
2. (Optional) **Installing the software** (copying files to system directories).

### 2. Build the Software

```bash
make -j4

```

This command will translate C++ source code into binaries.

* `-j4`: Tells the compiler to run 4 compilation tasks simultaneously to speed up the process.

After a successful build, you will see 2 folders:

* `build/lib`: Contains the libraries.
* `build/bin`: Contains the executables.

#### What is the difference between `build/lib` and `build/bin`?

**A. `build/lib` (The Libraries)**

* **What they are:** These are **Shared Objects** (on Linux, usually ending in `.so`), such as `libopencv_core.so`, `libopencv_highgui.so`, and `libopencv_dnn.so`. This **IS** the actual OpenCV framework. These files contain the compiled machine code for all computer vision functions.
* **How to use them:** You **cannot run** these files directly. Instead, when compiling your C++ application, you must link against these files. Your program loads them into memory at runtime to perform tasks like `cv::resize` or `cv::Mat`.
*Example:* If you are writing a C++ program:
```cpp
#include <opencv2/core.hpp>
#include <iostream>
// ... main function code ...

```


When compiling, you must provide the "ingredients" to the compiler (`g++`):
```bash
g++ test.cpp -o my_app \
  -I../opencv/include \
  -L./lib \
  -lopencv_core

```


* `-L`: Tells the linker to look for library files in this specific folder.
* `-l`: Tells the linker to link against a specific library file (e.g., `opencv_core`).


**Runtime Note:** If you try to run `./my_app` immediately, Linux might report: *"Shared library not found."*
* **Why?** At runtime, the operating system looks for shared libraries in default locations like `/usr/lib`, not your custom build folder.
* **Fix:** You must tell Linux where to look for this session using `LD_LIBRARY_PATH`:


```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/lib

```


Then run your app:
```bash
./my_app

```

* **Why is `LD_LIBRARY_PATH` necessary if I already compiled with `-L`?** The reason lies in the distinction between **Compile Time** and **Runtime**. 
  * The `-L` flag is strictly for the linker during the build process; it ***verifies that the library exists*** and ***resolves symbols*** so the executable can be created. However, the resulting executable typically stores only the library's *name* (e.g., `libopencv_core.dylib`), not its absolute path. 
  * When you run the application, the OS Dynamic Loader searches standard system directories (like `/usr/lib`) by default and is unaware of your custom `libs` folder. `LD_LIBRARY_PATH` (or `DYLD_LIBRARY_PATH` on macOS) acts as a runtime map, explicitly telling the OS where to find these non-standard shared libraries.


> **Note:** `LD_LIBRARY_PATH` is a predefined environment variable in Linux/Unix. It sets the path that the linker checks for dynamic/shared libraries. The linker prioritizes paths in this variable over standard system paths (`/lib`, `/usr/lib`). Standard paths are searched only after the `LD_LIBRARY_PATH` list is exhausted.



**B. `build/bin` (The Executables)**

* **What they are:** These are standalone **Programs**.
* **How to use them:** You run these directly from the terminal. They are complete applications that rely on the libraries in the `lib` folder to function.
*Example:* To check the exact version of the built OpenCV, execute the `opencv_version` tool directly:
```bash
./bin/opencv_version

# Output:
# 4.10.0

```



### 3. (Optional) Installing the Software into Your System

```bash
sudo make install

```

This command copies the binaries and headers you just built into the system's standard directories (typically `/usr/local/bin` and `/usr/local/lib`).

---

## Using OpenCV Without Installing It into Your System

**Question:** *If I don't run `sudo make install`, how can I use OpenCV?*

Skipping installation is a common practice, especially when testing multiple OpenCV versions or working on a shared server without `sudo` privileges. If you skip `sudo make install`, the files remain inside your `build` folder. To use them, you must explicitly configure your environment:

**1. Compile Time: Pointing to Headers (`-I`)**
The compiler needs to know where the `.hpp` files are located. You must verify the path to the `include` folder.

* Flag: `-I/home/user/opencv/include` (or the specific path to the source include directory).

**2. Link Time: Pointing to Libraries (`-L`)**
The linker needs to know where the `.so` files are located.

* Flag: `-L/home/user/opencv/build/lib`

**3. Run Time: The "Hidden" Step (`LD_LIBRARY_PATH`)**
This is where most issues occur. Your program may compile successfully, but crash immediately upon running:

```text
error while loading shared libraries: libopencv_core.so.4.x: cannot open shared object file: No such file or directory

```

* **Why?** At runtime, your executable knows it *needs* `libopencv_core.so`, but the Linux runtime loader defaults to checking global folders and cannot find it in your custom build directory.
* **Solution:** You must override the library path variable as mentioned in section 2:
```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/your/build/lib

```



### Note on CMake

Since manually typing `-I` and `-L` flags is tedious and error-prone, the standard way to handle these dependencies in modern C++ projects is by using **CMake** (via `find_package(OpenCV)` and `target_link_libraries`).

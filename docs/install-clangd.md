Clangd is often significantly faster and more accurate than the default Microsoft C/C++ IntelliSense.

Here is the complete setup guide to replace the Microsoft IntelliSense with clangd while keeping the Microsoft Debugger.

### Step 1: Install the clangd

1. Install extension in VS Code
2. Install clangd in your system
    ```bash
    apt-get install clangd
    ```

### Step 2: Disable Microsoft IntelliSense

You cannot run both engines at the same time; they will fight over code completion. You need to disable the Microsoft "brain" but keep the extension installed (because you still need it for **debugging**).

1. Open Command Palette (`Ctrl` + `Shift` + `P`).
2. Search for **Preferences: Open User Settings (JSON)** (or Workspace Settings).
3. Add (or modify) this setting:
```json
"C_Cpp.intelliSenseEngine": "disabled"

```


4. **Restart VS Code** (or reload the window) to ensure the change takes effect.

### Step 3: Generate the "Map" (`compile_commands.json`)

Clangd **strictly** relies on a file called `compile_commands.json`. This file tells clangd exactly how every file in your project is compiled (including where the OpenCV headers are).

Since you are using **CMake**, generating this is easy.

Add this line to your `CMakeLists.txt`, right after the `project(...)` line:

```cmake
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

```

### Step 4: Re-Configure to Apply

Now that you've turned that setting on, you must re-run the configure step we fixed earlier:

1. Command Palette: **CMake: Delete Cache and Reconfigure**.
2. Wait for it to finish.
3. Look inside your `build/` folder. You should now see a file named `compile_commands.json`. Nếu không thấy file `compile_commands.json`, có thể là do bạn chưa định nghĩa bất kỳ mục tiêu biên dịch nào (executable hoặc library). CMake chỉ tạo ra danh sách các lệnh biên dịch (compile_commands.json) khi nó biết cần biên dịch file nào. Bạn cần thêm lệnh add_executable (hoặc add_library) vào CMakeLists.txt

### Step 5: Verify Clangd is Working

**Fixing the "Headers Not Found" (Symlink):**
By default, clangd looks for `compile_commands.json` in the **root** of your workspace. CMake puts it in `build/`.

* **Automatic:** Newer versions of clangd usually check `build/` automatically.
* **Manual Fix:** If it fails, create a symlink in your terminal:
```bash
# Run this in your project root
ln -s build/compile_commands.json .

```
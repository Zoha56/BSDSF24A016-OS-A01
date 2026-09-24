# Operating Systems Assignment 1 - Report
**Repository:** BSDSF24A016-OS-A01  
**Author:** Zoha56  

---

## Feature 2: Multi-File Modular Standard Compilation

### Overview
Feature 2 modularizes the utility codebase into separate header files (`mystrfunctions.h`, `myfilefunctions.h`) and implementation source files (`mystrfunctions.c`, `myfilefunctions.c`). The driver program (`main.c`) consumes these modules using standard standard compilation routines via an explicit Makefile.

### Project Structure
- `include/`: Contains header declarations for string and file utility functions.
- `src/`: Contains source code implementation files and `main.c`.
- `obj/`: Directory holding intermediate object files (`.o`).
- `bin/`: Directory holding compiled output executables.

### Build and Compilation Process
Compilation is managed directly through explicit target rules without wildcard variables to ensure deterministic builds:
1. `mystrfunctions.c` is compiled to `obj/mystrfunctions.o`.
2. `myfilefunctions.c` is compiled to `obj/myfilefunctions.o`.
3. `main.c` is compiled to `obj/main.o`.
4. All object files are directly linked together using `gcc` into the target binary `bin/client`.


## Feature 3: Static Library Compilation & Analysis

### Overview
Feature 3 bundles the modular utility object files (`mystrfunctions.o`, `myfilefunctions.o`) into a single static library archive named `libmyutils.a`. The client application is then linked against this archive to produce the static executable `bin/client_static`.

### Build Commands
1. **Archive Creation:**  
   `ar rcs lib/libmyutils.a obj/mystrfunctions.o obj/myfilefunctions.o`
2. **Linking Step:**  
   `gcc obj/main.o -Llib -lmyutils -o bin/client_static`

---

## Feature 3 Analysis & Report Questions

### 1. Makefile Comparison (Feature 2 vs. Feature 3)
* **Part 2 (Multi-file direct linking):** Links raw object files directly into the target binary using `gcc`:
  ```makefile
  bin/client: obj/mystrfunctions.o obj/myfilefunctions.o obj/main.o
      gcc obj/mystrfunctions.o obj/myfilefunctions.o obj/main.o -o bin/client
---

## Feature 4: Dynamic Library Compilation & Analysis

### Overview
Feature 4 compiles position-independent object code (`-fPIC`) to build a shared dynamic library (`lib/libmyutils.so`). The client application (`bin/client_dynamic`) links dynamically against this shared object file at runtime using `-Wl,-rpath='$ORIGIN/../lib'`.

### Key Build Commands
1. **PIC Object Compilation:** `gcc -fPIC -Iinclude -c src/mystrfunctions.c -o obj/mystrfunctions_pic.o`
2. **Shared Library Generation:** `gcc -shared obj/mystrfunctions_pic.o obj/myfilefunctions_pic.o -o lib/libmyutils.so`
3. **Dynamic Executable Linking:** `gcc obj/main.o -Llib -lmyutils -Wl,-rpath='$ORIGIN/../lib' -o bin/client_dynamic`

---

## Feature 4 Analysis & Report Questions

### 1. Position-Independent Code (`-fPIC`)
* **Purpose:** `-fPIC` (Position-Independent Code) instructs the compiler to generate machine code using relative memory addresses rather than fixed, absolute addresses.
* **Why required:** Because shared libraries (`.so`) are loaded into arbitrary memory regions at runtime by different processes, code generated with `-fPIC` allows multiple processes to share the exact same physical memory pages for code execution without address conflicts.

### 2. Symbol Comparison (`nm -D` on `client_dynamic` vs. `client_static`)
* Running `nm -D bin/client_dynamic` shows functions like `mystrlen` marked with `U` (Undefined).
* **What this indicates:** Unlike `client_static` (where function code is fully embedded inside the binary), `client_dynamic` only stores a reference symbol for `mystrlen`. The actual function code remains inside `libmyutils.so` and is resolved by the OS dynamic linker (`ld.so`) when the program is launched.

### 3. Shared Library Search Path (`LD_LIBRARY_PATH` vs. `rpath`)
* **`LD_LIBRARY_PATH`:** An environment variable used to specify custom search directories for shared libraries at runtime.
* **`-Wl,-rpath`:** Embeds a runtime library search path directly inside the executable binary ELF header.
* **Why `-Wl,-rpath='$ORIGIN/../lib'` was used:** By setting the runtime path relative to `$ORIGIN` (the folder where the executable lives), `client_dynamic` can automatically locate `libmyutils.so` in `../lib` without requiring manual environment variable configuration (`LD_LIBRARY_PATH`) by the user.

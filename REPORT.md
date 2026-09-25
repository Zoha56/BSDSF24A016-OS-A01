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

---

## Feature 5: Creating and Accessing Custom Man Pages

### Overview
Feature 5 creates standard Linux manual pages in `groff`/`troff` format for custom string (`mystrfunctions.3`) and file (`myfilefunctions.3`) utility functions under Section 3 (Library Functions). An `install` target was added to the `Makefile` to automate system-wide installation of the binary executable to `/usr/local/bin` and manual pages to `/usr/local/share/man/man3/`.

### Key Commands
1. **Local Preview:** `man -l man/man3/mystrfunctions.3`
2. **System Installation:** `sudo make install`
3. **Global Execution & Access:** `client` and `man 3 mystrfunctions`
4. **System Uninstallation:** `sudo make uninstall`

---

## Feature 5 Analysis & Report Questions

### 1. Section Numbers in Man Pages
* **Section 1:** User Commands and Executables (e.g., `ls`, `grep`).
* **Section 2:** System Calls provided by the Linux Kernel (e.g., `open`, `fork`).
* **Section 3:** Library Functions provided by C/C++ libraries (e.g., `strcpy`, `printf`).
* **Why Section 3 was chosen:** `mystrfunctions` and `myfilefunctions` are utility library routines called inside standard C programs, making Section 3 the appropriate standard section.

### 2. Formatting Language
* Man pages are written using `groff`/`troff` macro formatting commands:
  - `.TH`: Title Header (defines page name, section number, date, and manual title).
  - `.SH`: Section Header (defines structural sections like NAME, SYNOPSIS, DESCRIPTION, AUTHOR).
  - `.B` / `.I`: Bold / Italic text styling for function signatures and parameters.
  - `.TP`: Tagged Paragraph (used for itemized function breakdowns).

### 3. Installation Directory and `sudo make install`
* The `install` target copies the compiled binary `bin/client` into `/usr/local/bin` and man pages into `/usr/local/share/man/man3/`.
* Writing files into `/usr/local/` requires elevated system privileges, which is why `sudo make install` is necessary.
* After running `mandb`, the system updates its database index so users can access `man 3 mystrfunctions` and execute `client` from any terminal path without specifying relative directory paths.

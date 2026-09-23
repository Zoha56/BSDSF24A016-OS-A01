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

---

---

## Feature 3: Static Library Compilation

### Overview
Feature 3 bundles the modular utility object files (`mystrfunctions.o`, `myfilefunctions.o`) into a single static library archive named `libmyutils.a`. The client application is then linked against this archive to produce the static executable `bin/client_static`.

### Build Commands
1. **Archive creation:** `ar rcs lib/libmyutils.a obj/mystrfunctions.o obj/myfilefunctions.o`
2. **Linking step:** `gcc obj/main.o -Llib -lmyutils -o bin/client_static`

### Key Observations & Symbol Inspection
- Running `ar -t lib/libmyutils.a` confirms that `mystrfunctions.o` and `myfilefunctions.o` are properly archived inside the library file.
- Inspecting symbols via `nm` displays exported utility function symbols directly embedded in the static build archive.
- The compiled static binary `client_static` includes all linked code routines directly inside the executable binary, making it self-contained without requiring separate external library files at runtime.

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

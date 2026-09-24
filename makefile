# --------------------------------------------------
# FEATURE-2: Standard Multi-file Executable
# --------------------------------------------------
bin/client: obj/mystrfunctions.o obj/myfilefunctions.o obj/main.o
	mkdir -p bin
	gcc obj/mystrfunctions.o obj/myfilefunctions.o obj/main.o -o bin/client

obj/mystrfunctions.o: src/mystrfunctions.c include/mystrfunctions.h
	mkdir -p obj
	gcc -Iinclude -c src/mystrfunctions.c -o obj/mystrfunctions.o

obj/myfilefunctions.o: src/myfilefunctions.c include/myfilefunctions.h
	mkdir -p obj
	gcc -Iinclude -c src/myfilefunctions.c -o obj/myfilefunctions.o

obj/main.o: src/main.c include/mystrfunctions.h include/myfilefunctions.h
	mkdir -p obj
	gcc -Iinclude -c src/main.c -o obj/main.o


# --------------------------------------------------
# FEATURE-3: Static Library (libmyutils.a)
# --------------------------------------------------
lib/libmyutils.a: obj/mystrfunctions.o obj/myfilefunctions.o
	mkdir -p lib
	ar rcs lib/libmyutils.a obj/mystrfunctions.o obj/myfilefunctions.o

bin/client_static: obj/main.o lib/libmyutils.a
	mkdir -p bin
	gcc obj/main.o -Llib -lmyutils -o bin/client_static


# --------------------------------------------------
# FEATURE-4: Dynamic Library (libmyutils.so)
# --------------------------------------------------

# 1. Compile PIC object files
obj/mystrfunctions_pic.o: src/mystrfunctions.c include/mystrfunctions.h
	mkdir -p obj
	gcc -fPIC -Iinclude -c src/mystrfunctions.c -o obj/mystrfunctions_pic.o

obj/myfilefunctions_pic.o: src/myfilefunctions.c include/myfilefunctions.h
	mkdir -p obj
	gcc -fPIC -Iinclude -c src/myfilefunctions.c -o obj/myfilefunctions_pic.o

# 2. Build shared library
lib/libmyutils.so: obj/mystrfunctions_pic.o obj/myfilefunctions_pic.o
	mkdir -p lib
	gcc -shared obj/mystrfunctions_pic.o obj/myfilefunctions_pic.o -o lib/libmyutils.so

# 3. Link main.o with shared library using rpath
bin/client_dynamic: obj/main.o lib/libmyutils.so
	mkdir -p bin
	gcc obj/main.o -Llib -lmyutils -Wl,-rpath='$$ORIGIN/../lib' -o bin/client_dynamic


# --------------------------------------------------
# Cleanup
# --------------------------------------------------
clean:
	rm -rf obj bin lib

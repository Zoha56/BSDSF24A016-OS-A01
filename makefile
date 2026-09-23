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

# 1. Archive function object files into static library
lib/libmyutils.a: obj/mystrfunctions.o obj/myfilefunctions.o
	mkdir -p lib
	ar rcs lib/libmyutils.a obj/mystrfunctions.o obj/myfilefunctions.o

# 2. Link main.o against libmyutils.a to create client_static
bin/client_static: obj/main.o lib/libmyutils.a
	mkdir -p bin
	gcc obj/main.o -Llib -lmyutils -o bin/client_static


# --------------------------------------------------
# Cleanup
# --------------------------------------------------
clean:
	rm -rf obj bin lib

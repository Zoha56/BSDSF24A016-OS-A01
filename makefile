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
obj/mystrfunctions_pic.o: src/mystrfunctions.c include/mystrfunctions.h
	mkdir -p obj
	gcc -fPIC -Iinclude -c src/mystrfunctions.c -o obj/mystrfunctions_pic.o

obj/myfilefunctions_pic.o: src/myfilefunctions.c include/myfilefunctions.h
	mkdir -p obj
	gcc -fPIC -Iinclude -c src/myfilefunctions.c -o obj/myfilefunctions_pic.o

lib/libmyutils.so: obj/mystrfunctions_pic.o obj/myfilefunctions_pic.o
	mkdir -p lib
	gcc -shared obj/mystrfunctions_pic.o obj/myfilefunctions_pic.o -o lib/libmyutils.so

bin/client_dynamic: obj/main.o lib/libmyutils.so
	mkdir -p bin
	gcc obj/main.o -Llib -lmyutils -Wl,-rpath='$$ORIGIN/../lib' -o bin/client_dynamic


# --------------------------------------------------
# FEATURE-5: System Install and Man Pages
# --------------------------------------------------
install: bin/client
	mkdir -p /usr/local/bin
	mkdir -p /usr/local/share/man/man3
	cp bin/client /usr/local/bin/client
	cp man/man3/*.3 /usr/local/share/man/man3/
	mandb /usr/local/share/man 2>/dev/null || true

uninstall:
	rm -f /usr/local/bin/client
	rm -f /usr/local/share/man/man3/mystrfunctions.3
	rm -f /usr/local/share/man/man3/myfilefunctions.3


# --------------------------------------------------
# Cleanup
# --------------------------------------------------
clean:
	rm -rf obj bin lib

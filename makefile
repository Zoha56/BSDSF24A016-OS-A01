# Link object files together into the target executable
bin/client: obj/mystrfunctions.o obj/myfilefunctions.o obj/main.o
	mkdir -p bin
	gcc obj/mystrfunctions.o obj/myfilefunctions.o obj/main.o -o bin/client

# Compile mystrfunctions.c
obj/mystrfunctions.o: src/mystrfunctions.c include/mystrfunctions.h
	mkdir -p obj
	gcc -Iinclude -c src/mystrfunctions.c -o obj/mystrfunctions.o

# Compile myfilefunctions.c
obj/myfilefunctions.o: src/myfilefunctions.c include/myfilefunctions.h
	mkdir -p obj
	gcc -Iinclude -c src/myfilefunctions.c -o obj/myfilefunctions.o

# Compile main.c
obj/main.o: src/main.c include/mystrfunctions.h include/myfilefunctions.h
	mkdir -p obj
	gcc -Iinclude -c src/main.c -o obj/main.o

# Clean compiled files
clean:
	rm -rf obj bin



main: library.o fcopy.o
	ld -m elf_i386 -o main library.o fcopy.o

library.o: library.asm
	nasm -f elf -g library.asm

fcopy.o: fcopy.asm
	nasm -f elf -g fcopy.asm

clean: 
	rm *.o main

debug: main
	gdb main

run: main
	./main

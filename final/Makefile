

main: library.o main.o
	ld -m elf_i386 -o main library.o main.o

library.o: library.asm
	nasm -f elf -g library.asm

main.o: main.asm
	nasm -f elf -g main.asm

clean: 
	rm *.o main

debug: main
	gdb main

run: main
	./main

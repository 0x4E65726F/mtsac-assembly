

main: main.o library.o
	ld -m elf_i386 -o main main.o library.o

main.o: main.asm
	nasm -f elf -g main.asm

library.o: library.asm
	nasm -f elf -g library.asm

clean:
	rm main main.o library.o

debug: main
	gdb main

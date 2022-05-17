

main: main.o array_lib.o
	ld -m elf_i386 -o main main.o array_lib.o

main.o: main.asm
	nasm -f elf -g main.asm

array_lib.o: array_lib.asm
	nasm -f elf -g array_lib.asm

clean:
	rm main array_lib.o main.o

debug: main
	gdb main

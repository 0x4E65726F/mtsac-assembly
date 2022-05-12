

main: main.o string_lib.o
	ld -m elf_i386 -o main main.o string_lib.o

main.o: main.asm
	nasm -f elf -g main.asm

string_lib.o: string_lib.asm
	nasm -f elf -g string_lab.asm

clean:
	rm main string_lib.o main.o

debug: main
	gdb main

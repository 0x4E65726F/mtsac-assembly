

main: main.o string.o
	ld -m elf_i386 -o main main.o string.o

main.o: main.asm
	nasm -f elf -g main.asm

string.o: string.asm
	nasm -f elf -g string_lab.asm

clean:
	rm main string.o main.o

debug: main
	gdb main

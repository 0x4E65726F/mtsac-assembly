

array_test: array_test.o array_lib.o
	ld -m elf_i386 -o array_test array_test.o array_lib.o

array_test.o: array_test.asm
	nasm -f elf -g array_test.asm

array_lib.o: array_lib.asm
	nasm -f elf -g array_lib.asm

clean:
	rm array_test array_lib.o array_test.o

debug: array_test
	gdb array_test

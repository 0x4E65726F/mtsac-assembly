

main: library.o student_contact.o
	ld -m elf_i386 -o main library.o student_contact.o

library.o: library.asm
	nasm -f elf -g library.asm

student_contact.o: student_contact.asm student_contact.inc
	nasm -f elf -g student_contact.asm

clean: 
	rm *.o main

debug: main
	gdb main

run: main
	./main

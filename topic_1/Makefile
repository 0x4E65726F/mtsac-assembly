BIN = main

all: $(BIN)

$(BIN): library.o final.o
	ld -m elf_i386 -o $@ $^

library.o: library.asm
	nasm -f elf -g $<
final.o: final.asm final.inc
	nasm -f elf -g $<

clean: 
	rm *.o $(BIN)

debug: main
	gdb $(BIN)

run: final
	./$(BIN)

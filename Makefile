all: array

array: array.asm
	nasm -f elf64 -o array.o array.asm
	ld -o array array.o
	./array

clean:
	rm -f *.o
	rm array

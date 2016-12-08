AS = nasm
ASFLAGS = -f elf64
CFLAGS =
CC = gcc

all: array io.o

array: array.o io.o
	$(CC) $(CFLAGS) -o array array.o io.o

array.o : io.inc array.asm
	$(AS) $(ASFLAGS) array.asm

io.o : io.asm
	$(AS) $(ASFLAGS) io.asm


clear:
	rm *.o
	rm array

AS = nasm
ASFLAGS = -f elf64
CFLAGS =
CC = gcc

all: array array2 shared.o

array: array.o shared.o
	$(CC) $(CFLAGS) -o array array.o shared.o

array2: array2.o shared.o
	$(CC) $(CFLAGS) -o array2 array2.o shared.o

array.o : shared.inc array.asm
	$(AS) $(ASFLAGS) array.asm

array2.o : shared.inc array2.asm
	$(AS) $(ASFLAGS) array2.asm

shared.o : shared.asm
	$(AS) $(ASFLAGS) shared.asm

clear:
	rm *.o
	rm array*

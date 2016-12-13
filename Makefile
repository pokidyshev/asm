AS = nasm
ASFLAGS = -f elf32
CFLAGS = -m32
CC = gcc

all: array array2 shared.o

array: array.o shared.o
	$(CC) $(CFLAGS) array.o shared.o -o array

array2: array2.o shared.o
	$(CC) $(CFLAGS) array2.o shared.o -o array2 

array.o : shared.inc array.asm
	$(AS) $(ASFLAGS) array.asm

array2.o : shared.inc array2.asm
	$(AS) $(ASFLAGS) array2.asm

shared.o : shared.asm
	$(AS) $(ASFLAGS) shared.asm

clear:
	rm *.o
	rm array, array2

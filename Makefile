AS = nasm
ASFLAGS = -f elf32
CFLAGS = -m32
CC = gcc

all: array array2 text shared.o

array: array.o shared.o
	$(CC) $(CFLAGS) array.o shared.o -o array

array2: array2.o shared.o
	$(CC) $(CFLAGS) array2.o shared.o -o array2 

text: text.o shared.o
	$(CC) $(CFLAGS) text.o shared.o -o text

array.o : shared.inc array.asm
	$(AS) $(ASFLAGS) array.asm

array2.o : shared.inc array2.asm
	$(AS) $(ASFLAGS) array2.asm

text.o : shared.inc text.asm
	$(AS) $(ASFLAGS) text.asm

shared.o : shared.asm
	$(AS) $(ASFLAGS) shared.asm

clear:
	rm *.o
	rm array array2 text

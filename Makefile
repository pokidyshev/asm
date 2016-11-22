all: hello.out

hello.out: hello.asm
	nasm -f elf64 -o hello.o hello.asm
	ld -o hello hello.o
	./hello > hello.out
	cat hello.out
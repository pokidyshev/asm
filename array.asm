; This a small assembly program which calculates whether 
; a fist sequence of positive numbers in an array is the longest

%define NEW_LINE 10

segment .data
positive db "YES!", NEW_LINE 
negative db "NO!", NEW_LINE
array    dd  1, 2, 3, 4, -1, 2, 2, 0, -1, 1

global _start                       ; the program entry point

_start:
	mov eax, 0 ; i=0
	mov     rax, 1                  ; system call 1 is write
	mov     rdi, 1                  ; file handle 1 is stdout
	mov     rdx, 8                  ; number of bytes
	
print_loop:
	mov     rsi, [array+eax]           ; address of item to output
	syscall                         ; invoke operating system to do the write
	add eax, 8 ; ++i (8 bytes)
	cmp eax, 8*10 ; if (i < 10)
	jne print_loop ; jump until i = 10 
	
	
	mov     eax, 60                 ; system call 60 is exit
	xor     rdi, rdi                ; exit code 0
	syscall                         ; invoke operating system to exit

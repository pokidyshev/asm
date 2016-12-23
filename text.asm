;;
;; How much words has the same first and last letters
;; as the forst word?
;; 
;; Requirements:
;;   1. Read one string from StdIn
;;   2. Print it to StdOut
;;   3. Push params to stack
;;   4. Use special string commands
;;

%include "shared.inc"

section .data
BUF_SIZE equ 1000

section .bss
buffer   resb   BUF_SIZE

section .text
    global main

main:
	writeln_literal "Type a string and press Enter"
	read buffer, BUF_SIZE   ; ecx has string

	writeln_literal "You have just entered:"
	write ecx, eax

	multipush ecx, eax
	call count_words
	mov  edi, eax
	multipop ecx, eax
	
	call itoa
	write eax, ecx
	writeln_literal "" ; just a new line

	exit 0

count_words:
	multipush esi, edx

    mov  esi, [esp+16]
    mov  edx, [esp+12]
    write esi, edx

    multipop esi, edx

	mov  eax, 0
	ret
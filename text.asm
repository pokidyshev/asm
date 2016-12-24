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

%macro skip_until 1
	push eax

	xor eax, eax
	mov al, %1
	repne scasb
	dec edi

	pop eax
%endmacro

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


;;
;; Params
;;   [esp+8] = string pointer
;;   [esp+4] = length
;;
count_words:
	multipush esi, edx
	mov  eax, 0

   	mov  edi, [esp+16]     ;  add ' ' before '.' 
    skip_until '.'
    mov  byte [edi], ' '
    mov  byte [edi+1], '.'
    
	mov edi, [esp+16]
	call .skip_spaces

	cmp byte [edi], '.'
	je  .return

	mov bl, byte [edi]       ; save first letter
	skip_until ' '
	mov dl, byte [edi-1]     ; save last

.count_loop:
	call .skip_spaces

	cmp byte [edi], '.'
	je  .return

	cmp bl, byte [edi]       ; cmp first letter
	jne .just_skip

	skip_until ' '
	cmp dl, byte [edi-1]     ; cmp last
	jne .count_loop

	inc eax
	jmp .count_loop

.just_skip:
	skip_until ' '
	jmp .count_loop

.return:
    multipop esi, edx
	ret

;;
;; Params
;;   edi = string pointer
;;
.skip_spaces:
	push eax

	xor eax, eax
	mov al, ' '
	repe scasb
	dec edi

	pop eax
	ret

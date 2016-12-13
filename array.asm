;;
;; This a small assembly program which calculates whether
;; a fist sequence of positive numbers in an array is the
;; longest
;;

%include "shared.inc"

section .data
    ARRAY_SIZE equ 10
  	array      dd  1, 2, 3, -4, 5, 6, -7, 8, -9, 0

section .text
    global main

main:
	mov   esi, array
	mov   edx, ARRAY_SIZE
	call  solve            ; returns to eax

	cmp   eax, 0
	jne   .no

	writeln_literal "yes"
	jmp   .exit
.no:
	writeln_literal "no"
.exit:
    exit 0
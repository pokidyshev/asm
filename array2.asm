;;
;; This a small assembly program which calculates whether
;; a fist sequence of positive numbers in an array is the
;; longest
;;

%include "shared.inc"

section .data
MAX_SIZE equ 20
BUF_SIZE equ 10

space    db " ",0
splen    equ $-space

section .bss
array    resd   MAX_SIZE
buffer   resb   BUF_SIZE

section .text
    global main

main:
    writeln_literal "Number of elements"
    read buffer, BUF_SIZE   ; ecx has string

    mov   edx, ecx
    call  atoi
    mov   edi, eax      ; edi has length

    writeln_literal "Elements one by one"
    mov   ebx, 0
    
.reading:
    cmp   ebx, edi
    jge   .end_reading

    read  buffer, BUF_SIZE
    mov   edx, ecx
    call  atoi
    mov   [array+ebx*4], eax
    inc   ebx
    jmp   .reading

.end_reading:
    writeln_literal "Array: "
    mov   ebx, 0

.writing:
    cmp   ebx, edi
    jge   .end_writing

    push  edi
    mov   edi, [array+ebx*4]
    inc   ebx
    call  itoa
    write eax, ecx
    write space, splen
    pop   edi
    jmp   .writing

.end_writing:
    writeln_literal ""

    mov   esi, array
    multipush esi, edi
    call  solve2            ; returns to eax
    multipop esi, edi
    
    cmp   eax, 0
    jne   .no

    writeln_literal "yes"
    jmp   .exit
.no:
    writeln_literal "no"
.exit:
    exit 0


solve2:
    multipush esi, edx

    mov  esi, [esp+16]
    mov  edx, [esp+12]
    call solve

    multipop esi, edx

    ret
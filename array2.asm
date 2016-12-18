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
    writeln_literal "Enter number of elements"
    read buffer, BUF_SIZE   ; ecx has string

    mov   edx, ecx
    call  atoi
    mov   edi, eax      ; edi has length

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

;;
;; String to integer
;; Params:
;;   edx = string pointer
;; Returns
;;   eax = number
;;
atoi:
    multipush  ecx, esi
    
    xor   eax, eax          ; zero a "result so far"
    mov   esi, 1

    movzx ecx, byte [edx]   ; get a character
    
    cmp   ecx, '-'
    jne   .next

    inc   edx
    mov   esi, -1

.next:
    movzx ecx, byte [edx]   ; get a character
    inc   edx               ; ready for next one
    
    cmp   ecx, '0'          ; valid?
    jb    .done
    cmp   ecx, '9'
    ja    .done
    
    sub   ecx, '0'          ; "convert" character to number
    imul  eax, 10           ; multiply "result so far" by ten
    add   eax, ecx          ; add in current digit
    jmp   .next             ; until done
.done:
    imul  eax, esi

    multipop  ecx, esi
    ret


itoa:
    multipush ebx, esi

    mov eax, edi         ; Move the passed in argument to rax
    lea edi, [buffer+10] ; load the end address of the buffer (past the very end)
    mov ecx, 10          ; divisor
    mov ebx, 0           ; ebx will contain 4 bytes representing the length of the string - start at zero

    mov esi, 1
    cmp eax, 0
    jge .divloop
    mov esi, -1
    imul eax, -1

.divloop:
    xor  edx, edx        ; Zero out rdx (where our remainder goes after idiv)
    idiv  ecx             ; divide rax (the number) by 10 (the remainder is placed in rdx)
    add  edx, 0x30       ; add 0x30 to the remainder so we get the correct ASCII value
    dec  edi             ; move the pointer backwards in the buffer
    mov  byte [edi], dl  ; move the character into the buffer
    inc  ebx             ; increase the length
    
    cmp  eax, 0          ; was the result zero?
    jnz  .divloop        ; no it wasn't, keep looping

    cmp  esi, -1
    jne  .return
    dec  edi
    mov  byte [edi], '-'
    inc  ebx

.return:
    mov  eax, edi     ; rdi now points to the beginning of the string - move it into rax
    mov  ecx, ebx     ; ebx contains the length - move it into rcx

    multipop ebx, esi
    ret
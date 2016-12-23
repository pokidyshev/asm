section .data
    SYS_WRITE equ 4
    STD_OUT   equ 1

    SYS_READ  equ 3
    STD_IN    equ 0

    BUF_SIZE  equ 10

section .bss
    buffer    resb BUF_SIZE

section .text
    global atoi, itoa
    global sys_read, sys_write
    global solve


;;
;; Check if a fist sequence of positive numbers 
;; in an array is the longest
;; Params:
;;   esi = pointer to the array
;;   edx = array length
;; Returns:
;;   eax = 0 if yes
;;
solve:
    push  ebx
    push  edi

    mov   ebx, 0             ; i = 0
    call  count_pos          ; count first sequence length
    mov   edi, eax           ; store it in edi
.next:                       ; check other sequences
    call  count_pos

    cmp   eax, edi           ; if there is a sequence with greater or equal length
    jge   .no                ;   answer - 'no'
    cmp   eax, 0             ; if end of array reached
    je    .yes               ;   answer - 'yes'
    jmp   .next              ; continue checking
.yes:
    mov   eax, 0
    jmp   .end
.no:
    mov   eax, 1 
.end:
    pop   edi
    pop   ebx

    ret



;;
;; count number of positive numbers
;; params:
;;   esi = pointer to the array
;;   ebx = start index
;;   edx = array length
;; ret:
;;   eax = length of the next positive subsequence
;;         0 if end of array reached
;;
count_pos:
    xor   eax, eax           ; counter = 0

    cmp   ebx, edx           ; if (i >= len)
    jge   .end               ;   return
    
.skip_neg:               
    cmp   dword [esi], 0     ; while (i != a.length && a[i] <= 0) {
    jg    .next_pos

    add   esi, 4             ; go to tho next element in the array
    inc   ebx                ; i++
    
    cmp   ebx, edx
    je    .end               ; i != a.length
    
    jmp   .skip_neg          ; }
      
.next_pos:                   ; do {
    inc   eax                ;   counter++
    add   esi, 4             ;   go to tho next element in the array
    inc   ebx                ;   i++
    
    cmp   ebx, edx           ;   if (i == len) 
    je    .end               ;     return
      
    cmp   dword [esi], 0
    jg    .next_pos          ; } while (a[i] > 0)

.end:
    ret

;;
;; Read string from standard input
;; Params:
;;   ecx = char buffer
;;   edx = buffer length
;; Returns:
;;   eax = length of the read string
;;
sys_read:
    push ebx

    mov  eax, SYS_READ
    mov  ebx, STD_IN
    int  0x80

    pop  ebx
    
    ret


;;
;; write string to standard output
;; params:
;;   ecx = pointer to the string
;;   edx = length of the string
;;
sys_write:
    push eax
    push ebx

    mov  eax, SYS_WRITE  ; use sys_write()
    mov  ebx, STD_OUT    ; we're writing to stdout
    int  0x80

    pop ebx
    pop eax
    
    ret

;;
;; String to integer
;; Params:
;;   edx = string pointer
;; Returns
;;   eax = number
;;
atoi:
    push  ecx
    push  esi
    
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

    pop  esi
    pop  ecx
    ret

;; 
;; Interger to string
;; Params
;;   edi = number
;; Returns
;;   eax = string
;;   ecx = length
;;
itoa:
    push ebx
    push esi

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
    idiv ecx             ; divide rax (the number) by 10 (the remainder is placed in rdx)
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

    pop esi
    pop ebx
    ret
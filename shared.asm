section .data
    SYS_WRITE equ 4
    STD_OUT   equ 1

    SYS_READ  equ 3
    STD_IN    equ 0


segment .text
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

    cmp   eax, edi           ; if there is a sequence with greater length
    jg    .no                ;   answer - 'no'
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

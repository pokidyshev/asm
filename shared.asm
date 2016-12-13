%macro multipush 1-* 
%rep %0 
    push %1 
%rotate 1 
%endrep 
%endmacro

%macro multipop 1-* 
%rep %0 
%rotate -1 
    pop %1 
%endrep 
%endmacro

section .data
    SYS_WRITE equ 1
    STD_OUT   equ 1

    SYS_READ  equ 3
    STD_IN    equ 0


segment .text
    global sys_read, sys_write, strlen
    global solve


;;
;; say 'yes' if a fist sequence of positive numbers 
;; in an array is the longest
;; params:
;;   rsi = pointer to the array
;;   rdx = array length
;;   
solve:
    multipush rbx, rdi

    mov   rbx, 0             ; i = 0
    call  count_pos          ; count first sequence length
    mov   rdi, rax           ; store it in rdi
.next:                     ; check other sequences
    call  count_pos

    cmp   rax, rdi           ; if there is a sequence with greater length
    jg    .no                ;   print 'no'
    cmp   rax, 0             ; if end of array reached
    je    .yes               ;   print 'yes'
    jmp   .next              ; continue checking
.yes:
    mov   rax, 0
    jmp   .end
.no:
    mov   rax, 1 
.end:
    multipop rbx, rdi
    ret



;;
;; count number of positive numbers
;; params:
;;   rsi = pointer to the array
;;   rbx = start index
;;   rdx = array length
;; ret:
;;   rax = length of the next positive subsequence
;;         0 if end of array reached
;;
count_pos:
    xor   rax, rax           ; counter = 0

    cmp   rbx, rdx           ; if (i >= len)
    jge   .end               ;   return
    
.skip_neg:               
    cmp   qword [rsi], 0     ; while (i != a.length && a[i] <= 0) {
    jg    .next_pos

    add   rsi, 8             ; go to tho next element in the array
    inc   rbx                ; i++
    
    cmp   rbx, rdx
    je    .end               ; i != a.length
    
    jmp   .skip_neg          ; }
      
.next_pos:                   ; do {
    inc   rax                ;   counter++
    add   rsi, 8             ;   go to tho next element in the array
    inc   rbx                ;   i++
    
    cmp   rbx, rdx           ;   if (i == len) 
    je    .end               ;     return
      
    cmp   qword [rsi], 0
    jg    .next_pos          ; } while (a[i] > 0)

.end:
    ret

  ;;
  ;; Read string from standard input
  ;; Params:
  ;;   rcx = char buffer
  ;;   rdx = buffer length
  ;; Returns:
  ;;   rax = length of the read string
  ;;
sys_read:
    push rbx

    mov rbx, STD_IN
    mov rax, SYS_READ
    int 80H

    pop rbx
    
    ret


;;
;; write string to standard output
;; params:
;;   rsi = pointer to the string
;;   rdx = length of the string
;;
sys_write:
    multipush rax, rdi

    mov   rax, SYS_WRITE  ; use sys_write()
    mov   rdi, STD_OUT    ; we're writing to stdout
    syscall

    multipop rax, rdi
    
    ret


;;
;; calculate length of string
;; params:
;;   rdi = pointer to the string
;; returns:
;;   rax = length of string
;;
strlen:
    push  rcx            ; save and clear out counter
    xor   rcx, rcx

.next:
    cmp   [rdi], byte 0  ; null byte yet?
    jz    .zero          ; yes, get out

    inc   rcx            ; char is ok, count it
    inc   rdi            ; move to next char
    jmp   .next          ; process again

.zero:
    mov   rax, rcx       ; rcx = the length (put in rax)

    pop   rcx            ; restore rcx
    ret                  ; get out

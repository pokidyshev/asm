;;
;; This a small assembly program which calculates whether
;; a fist sequence of positive numbers in an array is the
;; longest
;;

%include "io.inc"

section .data
  	SYS_EXIT   equ 60
  	EXIT_CODE  equ 0

    ARRAY_SIZE equ 10
  	ARRAY      dq  1, 2, 3, -4, 5, 6, -7, 8, -9, 0

section .text
    global main
    global fist_pos_longest

main:
	push  rbp		; set up stack frame
	push  rsi
	push  rdx
	
	mov   rsi, ARRAY
	mov   rdx, ARRAY_SIZE
	call first_pos_longest

	pop   rdx
	pop   rsi
	pop	  rbp		; restore stack

    jmp   exit


;;
;; say 'yes' if a fist sequence of positive numbers 
;; in an array is the longest
;; params:
;;   rsi = pointer to the array
;;   rdx = array length
;;   
first_pos_longest:
	push  rbx
	push  rdi
	push  rax
	
	mov   rbx, 0             ; i = 0

	call  count_pos          ; count first sequence length
	mov   rdi, rax			 ; store it in rdi

next_subseq:                 ; check other sequences
	call  count_pos

	cmp   rax, rdi           ; if there is a sequence with greater length
	jg    no                 ; print 'no'

	cmp   rax, 0             ; if end of array reached
	je    yes                ; print 'yes'

	jmp   next_subseq        ; continue checking

yes:
	println_literal "yes"
	jmp   first_pos_ret
no: 
	println_literal "no"

first_pos_ret:
	pop   rax
	pop   rdi	
	pop   rbx

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
    jge   count_pos_end      ; 	 return
	
count_pos_neg:               
	cmp   qword [rsi], 0     ; while (i != a.length && a[i] <= 0) {
	jg   count_pos_next

	add   rsi, 8             ; go to tho next element in the array
    inc   rbx                ; i++
	
	cmp   rbx, rdx
    je    count_pos_end      ; i != a.length
	
	jmp   count_pos_neg	     ; }
    
count_pos_next:              ; do {
    inc rax                  ;   counter++
	add   rsi, 8             ;   go to tho next element in the array
    inc   rbx                ;   i++
	
	cmp   rbx, rdx           ;   if (i == len) 
    je    count_pos_end      ; 	   return
		
    cmp   qword [rsi], 0
    jg    count_pos_next     ; } while (a[i] > 0)

count_pos_end:
	ret


;;
;; Exit from program
;;
exit:
	mov     eax, SYS_EXIT                 ; system call 60 is exit
    mov     rdi, EXIT_CODE                ; exit code 0
    syscall                               ; invoke operating system to exit

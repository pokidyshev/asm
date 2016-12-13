; include C function
extern	printf
; include my I/O functions
extern  strlen, sys_write, sys_read
; include solver
extern  solve

; '\n' character
%define NEW_LINE    10

; sz - defines a zero terminated string
%macro sz 2
  jmp %%after_str       ; jump over the string that we define
  %1 db %2, 0           ; declare the string
%%after_str:            ; continue on
%endmacro

; szn - defines a zero terminated string + new line
%macro szn 2
  jmp %%after_str       ; jump over the string that we define
  %1 db %2, NEW_LINE, 0 ; declare the string
%%after_str:            ; continue on
%endmacro

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

;;
;; Read strind from standard input
;; Params:
;;   1 = char buffer
;;   2 = buffer length
;;
%macro read 2
    multipush rcx, rdx

    mov   rcx, %1
    mov   rdx, %2
    call  sys_read
    
    multipop rcx, rdx
%endmacro


;;
;; print string to standard output
;; params
;;   1 = pointer to the string
;;   2 = length of the string
;;
%macro print_len 2
    multipush rsi, rdx, rcx

    mov   rsi, %1       ; load the address of the string to sys_write
    mov   rdx, %2       ; load the length of the string to sys_write
    call  sys_write     ; print the string

    multipop rsi, rdx, rcx
%endmacro

;;
;; print string to standard output
;; params
;;   1 = pointer to the string
;;
%macro print 1
    multipush rdi, rax, rcx

    mov   rdi, %1       ; load the address of the string
    call  strlen        ; calculate length
    print_len %1, rax   ; length in rax

    multipop rdi, rax, rcx
%endmacro

%macro print_literal 1
    sz %%literal, %1
    print %%literal
%endmacro

%macro println_literal 1
    print_literal %1
    print_literal NEW_LINE
%endmacro

%macro println 1
    print %1
    print_literal NEW_LINE
%endmacro

%macro print_fmt 2
	szn %%fmt, %1

    multipush rdi, rsi, rax

	mov	rdi, %%fmt		; format for printf
	mov	rsi, %2         ; first parameter for printf
	mov	rax, 0		    ; no xmm registers
    call     printf		; Call C function

    multipop rdi, rsi, rax
%endmacro

%macro print_fmt 3
	szn %%fmt, %1

    multipush rdi, rsi, rdx, rax, rcx
	
    mov	rdi, %%fmt		; format for printf
	mov	rsi, %2         ; first parameter for printf
	mov rdx, %3         ; second
	mov	rax, 0		    ; no xmm registers
    call     printf		; Call C function

    multipop rdi, rsi, rdx, rax, rcx
%endmacro

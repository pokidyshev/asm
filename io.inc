; include C function
extern	printf
; include my I/O functions
extern  strlen, sys_write

; '\n' character
%define NEW_LINE	10

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

;;
;; print string to standard output
;; params
;;   1 = pointer to the string
;;
%macro print 1
    push  rdi           ; start off by preserving the registers
    push  rsi           ; that we know that we'll trash in this proc
    push  rdx
    push  rax

    mov   rdi, %1       ; load the address of the string
    call  strlen        ; calculate length

    mov   rsi, %1       ; load the address of the string to sys_write
    mov   rdx, rax      ; load the length of the string to sys_write
    call  sys_write     ; print the string

    pop   rax           ; restore all of the registers
    pop   rdx
    pop   rsi
    pop   rdi
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

	push rdi
	push rsi
	push rax 

	mov	rdi, %%fmt		; format for printf
	mov	rsi, %2         ; first parameter for printf
	mov	rax, 0		    ; no xmm registers
    call     printf		; Call C function

    pop rax
    pop rsi
    pop rdi
%endmacro

%macro print2_fmt 3
	szn %%fmt, %1

	push rdi
	push rsi
	push rdx
	push rax 

	mov	rdi, %%fmt		; format for printf
	mov	rsi, %2         ; first parameter for printf
	mov rdx, %3         ; second
	mov	rax, 0		    ; no xmm registers
    call     printf		; Call C function

    pop rax
    pop rdx
    pop rsi
    pop rdi
%endmacro

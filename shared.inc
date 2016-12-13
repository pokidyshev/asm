; include my I/O functions
extern  sys_write, sys_read
; include solver
extern  solve

; '\n' character
%define NL 10

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

; szn - defines a zero terminated string + new line
%macro szn 2
  jmp %%after_str       ; jump over the string that we define
  %1 db %2, NL, 0       ; declare the string
%%after_str:            ; continue on
%endmacro

%macro exit 1
    mov  eax, 1          ; eax = 1 for sys_exit()
    mov  ebx, %1         ; exit code
    int  0x80            ; call interrupt
%endmacro

;;
;; print string to standard output
;; params
;;   1 = pointer to the string
;;   2 = length of the string
;;
%macro write 2
    mov   ecx, %1       ; load the address of the string to sys_write()
    mov   edx, %2       ; load the length of the string to sys_write()
    call  sys_write     ; print the string
%endmacro

;;
;; Read string from standard input
;; params
;;   1 = pointer to the buffer
;;   2 = length of the buffer
;;
%macro read 2
    mov   ecx, %1       ; load the address of the string to sys_read()
    mov   edx, %2       ; load the length of the string to sys_read()
    call  sys_read      ; read a string
%endmacro

%macro writeln_literal 1
    szn %%literal, %1
    %%len equ $ - %%literal
    write %%literal, %%len
%endmacro

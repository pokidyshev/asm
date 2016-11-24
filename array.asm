;
; This a small assembly program which calculates whether
; a fist sequence of positive numbers in an array is the
; longest
;

; '\n' character
%define NEW_LINE	10

; sz - defines a zero terminated string
%macro sz 2
  jmp %%after_str       ; jump over the string that we define
  %1 db %2, 0           ; declare the string
%%after_str:            ; continue on
%endmacro

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

section .data
  	SYS_WRITE  equ 1
  	STD_OUT    equ 1
  	SYS_EXIT   equ 60
  	EXIT_CODE  equ 0

    ARRAY_SIZE equ 10
  	arr        db  1, 2, 3, -1, 2, -4, -5, 0, -2, 0

section .text
    global  _start

_start:
    println_literal "m1"
    sz m2, "m2"
    println m2
    jmp exit

;;
;; write string to standard output
;; params:
;;   rsi = pointer to the string
;;   rdx = length of the string
;;
sys_write:
    push  rax             ; start off by preserving the registers
    push  rdi             ; that we know that we'll trash in this proc

    mov   rax, SYS_WRITE  ; use sys_write()
    mov   rdi, STD_OUT    ; we're writing to stdout
    syscall

    pop   rdi             ; restore all of the registers
    pop   rax

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

strlen_next:

  cmp   [rdi], byte 0  ; null byte yet?
  jz    strlen_zero    ; yes, get out

  inc   rcx            ; char is ok, count it
  inc   rdi            ; move to next char
  jmp   strlen_next    ; process again

strlen_zero:

  mov   rax, rcx       ; rcx = the length (put in rax)

  pop   rcx            ; restore rcx
  ret                  ; get out


;;
;; Exit from program
;;
exit:
  	mov	rax, SYS_EXIT	     ; syscall number
  	mov	rdi, EXIT_CODE	   ; exit code
  	syscall			           ; call sys_exit

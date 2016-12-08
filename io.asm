section .data
    SYS_WRITE equ 1
    STD_OUT   equ 1


segment .text
    global sys_write, strlen

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

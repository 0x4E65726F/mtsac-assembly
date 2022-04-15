; who: Nero Li, yli342
; what: Test all of the flag values on slide 40 of Lecture 4a Data Transfer
; why: Lab 4a Exercise
; when: 2022-03-27

section     .text

global      _start

_start:

    mov     al, -128
    neg     al          ; CF = ? OF = ?

    mov     ax, 8000h
    add     ax, 2       ; CF = ? OF = ?

    mov     ax, 0
    sub     ax, 2       ; CF = ? OF = ?

    mov     al, -5
    sub     al, +125    ; CF = ? OF = ?

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss

section     .data


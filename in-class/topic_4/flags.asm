; who: <your name and Mt SAC username goes here>
; what: <the function of this program>
; why: <the name of the lab>
; when: < the due date of this lab.

section     .text

global      _start

_start:
    mov     eax, 0x8fff
    add     eax, 0x7fff
    mov     esi, sum

    mov     [esi + 4], eax
exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    sum     resd    1



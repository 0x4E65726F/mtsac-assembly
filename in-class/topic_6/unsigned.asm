; who: Nero Li, yli342
; what: <the function of this program>
; why: <the name of the lab>
; when: 2022-MM-DD

section     .text

global      _start

_start:
    ; var4 = ((var1 * var2) - vae3) / var4
    mov     ax, [var1]
    mov     bx, [var2]
    mul     bx
    sub     ax, [var3]
    mov     bx, [var4]
    div     bx
    mov     [var4], ax

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss

section     .data
    var1:   dw  12
    var2:   dw  10
    var3:   dw  5
    var4:   dw  10

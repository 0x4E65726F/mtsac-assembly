; who: Nero Li, yli342
; what: <the function of this program>
; why: <the name of the lab>
; when: 2022-MM-DD

section     .text

global      _start

_start:
    ; eax = ((var2 * 5) / (var2 - var3)) % var4
    mov     ax, [var2]
    mov     bx, [var3]
    imul    bx
    mov     cx, ax
    mov     ax, [var2]
    sub     ax, [var3]
    push    ax
    mov     ax, cx
    pop     bx
    idiv    bx
    mov     bx, [var4]
    idiv    bx
    mov     edx, eax

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

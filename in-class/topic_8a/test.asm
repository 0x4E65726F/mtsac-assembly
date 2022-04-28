section     .text

global      _start

extern      swap1
extern      swap2

_start:

    mov     eax, 10
    push    eax
    mov     ebx, 20
    push    ebx
    call    swap1
    pop     ebx
    pop     eax

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss

section     .data

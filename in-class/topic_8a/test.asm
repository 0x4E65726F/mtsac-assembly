section     .text

global      _start

extern      exit
extern      swap1
extern      swap2

_start:

    mov     eax, 10
    push    eax
    mov     ebx, 20
    push    ebx
    call    swap1
    call    swap2
    pop     ebx
    pop     eax
    mov     eax, 0
    call    exit

section     .bss

section     .data

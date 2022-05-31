extern      exit

section     .text

global      _start

_start:
    push    ebp
    mov     ebp, esp
    sub     esp, 4

    mov     eax, 0x2d
    xor     ebx, ebx
    int     0x80
    mov     [ebp - 4], eax

    push    dword 0
    call    exit

section     .bss

section     .data

section     .text

global      _start

_start:
mov     eax, 123
.loop_for_reverse:
    xor     edx, edx
    mov     ebx, 10
    div     ebx
    mov     [dig], edx
    mov     [orig], eax
    mov     eax, [revd]
    mov     ebx, 10
    mul     ebx
    add     eax, [dig]
    mov     [revd], eax
    mov     eax, [orig]
    cmp     eax, 0
    jne     .loop_for_reverse
mov     eax, [revd]

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    orig    resd    1
    revd    resd    1
    dig     resd    1

section     .data


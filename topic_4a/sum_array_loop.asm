; who: Nero Li, yli342
; what: Sum all of the values in the array and store that sum in arraySum
; why: Lab 4a Exercise
; when: 2022-03-27

section     .text

global      _start

_start:
    xor     eax, eax
    mov     ecx, 10
    mov     esi, intArray

.loop:
    add     eax, [esi + (ecx * 4) - 4]
    loop    .loop

exit:  
    mov         ebx, 0                                              ; return 0 status on exit - 'No Errors'
    mov         eax, 1                                              ; invoke SYS_EXIT (kernel opcode 1)
    int         80h

section     .bss
    arraySum    resd    1                                           ; memory location for sum of values

section     .data
    intArray    dd      1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 0Ah     ; initialized double-word array containing 10 consecutive integers
    arrayLen    equ     $ - intArray

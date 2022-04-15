; who: Nero Li, yli342
; what: Sum all of the values in the array and store that sum in arraySum
; why: Lab 4a Exercise
; when: 2022-03-27

section     .text

global      _start

_start:

    mov         eax, [intArray]                                     ; move 1st value in intArray into accumulator
    add         eax, [intArray + 4]                                 ; add 2nd value in intArray into accumulator
    add         eax, [intArray + 8]                                 ; add 3rd value in intArray into accumulator
    add         eax, [intArray + 12]                                 ; add 4th value in intArray into accumulator
    add         eax, [intArray + 16]                                 ; add 5th value in intArray into accumulator
    add         eax, [intArray + 20]                                 ; add 6th value in intArray into accumulator
    add         eax, [intArray + 24]                                 ; add 7th value in intArray into accumulator
    add         eax, [intArray + 28]                                 ; add 8th value in intArray into accumulator
    add         eax, [intArray + 32]                                 ; add 9th value in intArray into accumulator
    add         eax, [intArray + 36]                                 ; add 10th value in intArray into accumulator
    mov         [arraySum], eax

exit:  
    mov         ebx, 0                                              ; return 0 status on exit - 'No Errors'
    mov         eax, 1                                              ; invoke SYS_EXIT (kernel opcode 1)
    int         80h

section     .bss
    arraySum    resd    1                                           ; memory location for sum of values

section     .data
    intArray    dd      1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 0Ah     ; initialized double-word array containing 10 consecutive integers

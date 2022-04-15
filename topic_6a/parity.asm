; who: Nero Li, yli342
; what: A program that jumps to a label if AL has even or odd parity. 
; why: Lab 6a
; when: 2022-04-18

section     .text

global      _start

extern      print_string

_start:

    mov     esi, array
    mov     ecx, arrayLen

    .loop:
    push    ecx
    mov     al, byte [esi]
    mov     bl, 2
    xor     edx, edx
    idiv    ebx
    cmp     edx, 1
    jne     .true
    cmp     edx, 0
    jne     .false

    .true:
    mov     eax, truePrompt
    mov     ebx, ture_sz
    jmp     .next

    .false:
    mov     eax, falsePrompt
    mov     ebx, false_sz
    jmp     .next

    .next:
    call    print_string
    inc     esi
    pop     ecx
    loop    .loop

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    
section     .data
    array:          db      1, 2, 3, 4
    arrayLen:       equ     $ - array
    truePrompt:     db      "AL has even parity.", 0x0A
    ture_sz:        equ     $ - truePrompt
    falsePrompt:    db      "AL has odd parity.", 0x0A
    false_sz:       equ     $ - falsePrompt

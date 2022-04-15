; who: Nero Li, yli342
; what: A program that jumps to a label if either bit 4, 5, or 6 is set in the BL register. 
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
    mov     bl, byte [esi]
    test    bl, 00001000b
    jnz     .true
    test    bl, 00010000b
    jnz     .true
    test    bl, 00100000b
    jnz     .true
    test    bl, 00111000b
    jz      .false

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
    array:          db      1, 2, 4, 8, 16, 32, 64
    arrayLen:       equ     $ - array
    truePrompt:     db      "Bits 4, 5, or 6 are set.", 0x0A
    ture_sz:        equ     $ - truePrompt
    falsePrompt:    db      "Bits 4, 5, or 6 are not set.", 0x0A
    false_sz:       equ     $ - falsePrompt

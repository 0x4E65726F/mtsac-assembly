; who: Nero Li, yli342
; what: A program that jumps to a label if EAX is negative or positive.
; why: Lab 6a
; when: 2022-04-18

section     .text

global      _start

extern      print_string

_start:

    mov     esi, array
    mov     ecx, arrayLen
    mov     ebx, 4
    mov     eax, ecx
    idiv    ebx
    mov     ecx, eax

    .loop:
    push    ecx
    mov     eax, [esi]
    mov     ebx, 0
    cmp     eax, ebx
    jl      .true
    cmp     eax, ebx
    jge     .false

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
    add     esi, 4
    pop     ecx
    loop    .loop

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    
section     .data
    array:          dd      1, 0, -1
    arrayLen:       equ     $ - array
    truePrompt:     db      "The value in EAX is negative.", 0x0A
    ture_sz:        equ     $ - truePrompt
    falsePrompt:    db      "The value in EAX is not negative.", 0x0A
    false_sz:       equ     $ - falsePrompt

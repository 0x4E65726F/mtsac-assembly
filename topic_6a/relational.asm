; who: Nero Li, yli342
; what: A program that jumps to a label on the comparison of EAX and EBX. 
; why: Lab 6a
; when: 2022-04-18

section     .text

global      _start

extern      print_string

_start:

    mov     esi, array
    mov     ecx, arrayLen
    mov     ebx, 8
    mov     eax, ecx
    idiv    ebx
    mov     ecx, eax

    .loop:
    push    ecx
    mov     eax, [esi]
    add     esi, 4
    mov     ebx, [esi]
    cmp     eax, ebx
    ja      .above
    cmp     eax, ebx
    je      .equal
    cmp     eax, ebx
    jb      .below

    .above:
    mov     eax, PromptBigger
    mov     ebx, bigger_sz
    jmp     .next

    .equal:
    mov     eax, PromptEqual
    mov     ebx, equal_sz
    jmp     .next

    .below:
    mov     eax, PromptSmaller
    mov     ebx, smaller_sz
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
    ibuf:       resb    30
    ibuf_sz:    equ     $ - ibuf
    
section     .data
    array:          dd      5, 10, 10, 5, 5, 5
    arrayLen:       equ     $ - array
    PromptBigger:   db      "EAX > EBX", 0x0A
    bigger_sz:      equ     $ - PromptBigger
    PromptSmaller:  db      "EBX > EAX", 0x0A
    smaller_sz:     equ     $ - PromptSmaller
    PromptEqual:    db      "EAX == EBX", 0x0A
    equal_sz:       equ     $ - PromptEqual

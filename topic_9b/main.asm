; who: Nero Li, yli342
; what: A program that tests each procedure in string_lib.asm
; why: Lab 9a: String Procedures
; when: 2022-05-18

section     .text

global      _start

extern  bubble_sort_d
extern  bin_search_d

_start:
    push    array_sz
    push    array
    call    bubble_sort_d

    pop     eax
    pop     eax
    push    dword [search]
    push    array_sz
    push    array
    call    bin_search_d
    mov     ebx, [eax]

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss     

section     .data
    array:      dd      1, 3, 2, 5, 4, 8, 9, 6, 7
    array_sz:   equ     $ - array
    search:     dd      7
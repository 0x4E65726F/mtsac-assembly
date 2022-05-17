; who: Nero Li, yli342
; what: A program that tests each procedure in string_lib.asm
; why: Lab 9a: String Procedures
; when: 2022-05-18

section     .text

global      _start

extern      size_of
extern      print_string

_start:
    mov     esi, source     ; move source string address into esi
    mov     edi, dest       ; move destination string address into edi

    push    esi             ; push arg1
    call    print_string
    pop     esi             ; pop arg1

    push    edi             ; push arg2
    push    esi             ; push arg1
    call    string_copy
    pop     esi             ; pop arg1
    pop     edi             ; pop arg2

    push    edi             ; push arg1
    call    print_string
    call    to_upper
    call    print_string
    call    to_lower
    call    print_string
    pop     edi             ; pop arg1

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    dest:       resb    20      

section     .data
    source:     db      "Hello world!", 0Ah, 0

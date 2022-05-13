; who: Nero Li, yli342
; what: A program that tests each procedure in string_lib.asm
; why: Lab 9a: String Procedures
; when: 2022-05-18

section     .text

global      _start

extern      size_of
extern      print_string
extern      string_copy
extern      to_lower
extern 	    to_upper

_start:
    push    source
    call    print_string

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss

section     .data
    source:  db  "Hello world!", 0Ah, 0
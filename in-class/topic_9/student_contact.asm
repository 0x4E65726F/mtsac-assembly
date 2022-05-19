%include "student_contact.inc"

section     .text

global      _start

_start:
    push    ebp             ; preserve ebp
    mov     ebp, esp        ; establish base pointer
    push    word 0          ; local var initalized to 0
    ;sub     esp, 1
    ;mov     byte [esp - 4], 0

    push    dword 0         ; push exitcode
    call    exit            ; call exit

section     .bss
    student_array_sz:   equ     24
    student_array:      resb    (student_array_sz * student_contact_size)


section     .data


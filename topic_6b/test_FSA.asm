; who: Nero Li, yli342
; what: Write 2 procedures to implement a random integer generator.
; why: Lab 6b
; when: 2022-04-20

section     .text

global      _start

extern      print_string
extern      endl
extern      get_input
extern      exit
extern      atoi
extern      itoa
extern      legal_string_input

_start:

    mov     eax, testStr1
    mov     ebx, sz_1
    call    legal_string_input

    mov     eax, 0
    call    exit

section     .bss
    buf:        resb    2048
    buf_sz:     equ     $ - buf

section     .data
    testStr1:   db      "+1054"
    sz_1:       equ     $ - testStr1
    testStr2:   db      "+0054"
    sz_2:       equ     $ - testStr2
    testStr3:   db      "-1054"
    sz_3:       equ     $ - testStr3
    testStr4:   db      "a1054"
    sz_4:       equ     $ - testStr4
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

    mov     eax, testStr2           
    mov     ebx, sz_2
    call    legal_string_input

    mov     eax, testStr3           
    mov     ebx, sz_3
    call    legal_string_input

    mov     eax, testStr4           
    mov     ebx, sz_4
    call    legal_string_input

    mov     eax, testStr5           
    mov     ebx, sz_5
    call    legal_string_input

    mov     eax, testStr6           
    mov     ebx, sz_6
    call    legal_string_input

    mov     eax, 0                  
    call    exit

section     .bss
    buf:        resb    2048
    buf_sz:     equ     $ - buf

section     .data
    testStr1:   db      "123"           ; b 23 for first test result
    sz_1:       equ     $ - testStr1
    testStr2:   db      "+1234"         ; b 27 for second result
    sz_2:       equ     $ - testStr2
    testStr3:   db      "-1234"         ; b 31 for third result
    sz_3:       equ     $ - testStr3
    testStr4:   db      "a123"          ; b 35 for forth result
    sz_4:       equ     $ - testStr4
    testStr5:   db      "123a"          ; b 39 for fifth result
    sz_5:       equ     $ - testStr5
    testStr6:   db      "12-3"          ; b 43 for sixth result
    sz_6:       equ     $ - testStr6
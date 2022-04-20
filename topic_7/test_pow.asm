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
extern      pow

_start:
    mov     eax, basebuf
    mov     ebx, basebuf_sz
    call    get_input
    call    atoi
    mov     [base], eax

    mov     eax, expbuf
    mov     ebx, expbuf_sz
    call    get_input
    call    atoi
    mov     [exp], eax

    mov     eax, [base]
    mov     ebx, [exp]

    mov     ebx, obuf
    mov     ecx, obuf_sz
    call    itoa
    mov     eax, obuf
    mov     ebx, obuf_sz
    call    print_string
    call    endl

    mov     eax, 0                  
    call    exit

section     .bss
    basebuf:    resb    10
    basebuf_sz: equ     $ - buf
    expbuf:     resb    10
    expbuf_sz:  equ     $ - buf
    obuf:       resb    1024
    obuf_sz:    equ     $ - buf
    base:       resd    1
    exp:        resd    1

section     .data
    
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
    .get_base:
    mov     eax, prompt_a
    mov     ebx, plen_a
    call    print_string
    mov     eax, ibuf
    mov     ebx, ibuf_sz
    call    get_input
    mov     ebx, eax
    dec     ebx
    mov     eax, ibuf
    call    atoi
    mov     [base], eax

    .get_exp:
    mov     eax, prompt_b
    mov     ebx, plen_b
    call    print_string
    mov     eax, ibuf
    mov     ebx, ibuf_sz
    call    get_input
    mov     ebx, eax
    dec     ebx
    mov     eax, ibuf
    call    atoi
    mov     [exp], eax

    .calc:
    mov     eax, [base]
    mov     ebx, [exp]
    call    pow

    .output_result:
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
    ibuf:       resb    10
    ibuf_sz:    equ     $ - ibuf
    obuf:       resb    10
    obuf_sz:    equ     $ - obuf
    base:       resd    1
    exp:        resd    1

section     .data
    prompt_a:   db      'Enter base value: ' 
    plen_a:     equ     $ - prompt_a
    prompt_b:   db      'Enter exponent value: ' 
    plen_b:     equ     $ - prompt_b

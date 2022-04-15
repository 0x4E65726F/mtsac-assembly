; who: Nero Li, yli342
; what: <the function of this program>
; why: <the name of the lab>
; when: 2022-MM-DD

section     .text

global      _start

extern      print_string
extern      get_input
extern      exit
extern      atoi
extern      itoa

_start:

    mov     eax, prompt
    mov     ebx, psz
    call    print_string

    mov     eax, ibuf
    mov     ebx, ibuf_sz
    call    get_input

    mov     ebx, eax
    dec     ebx
    mov     eax, ibuf
    call    atoi

    mov     [intval], eax

    mov     ebx, ibuf
    mov     ecx, ibuf_sz
    call    itoa

    mov     ebx, eax
    mov     edi, ibuf
    add     edi, ebx
    mov     byte [edi], 0x0A
    inc     ebx
    mov     eax, ibuf
    call    print_string

    mov     eax, 0
    call    exit

section     .bss
    ibuf:       resb    30
    ibuf_sz:    equ     $ - ibuf
    intval:     resd    1

section     .data
    prompt:     db      "Enter an unsigned integer: "
    psz:        equ     $ - prompt
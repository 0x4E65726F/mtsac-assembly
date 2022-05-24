; who: Nero Li, yli342
; what: <the function of this program>
; why: <the name of the lab>
; when: 2022-MM-DD

section     .text

global      _start
extern      print_string
extern      reverse_string
extern      exit
extern      swap
extern      arraySearch

_start:
    push    dword 12
    push    array_sz
    push    array
    call    arraySearch
    pop     eax
    pop     eax
    pop     eax

break:
    push    dword 0             ; push exit code
    call    exit

section     .bss

section     .data
    array:      dd      1, 3, 2, 5, 4, 8, 9, 6, 7, 0
    array_sz:   equ     $ - array

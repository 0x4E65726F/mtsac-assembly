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
extern      current_time
extern      srand
extern      rand

_start:


section     .bss
    buf:        resb    2048
    buf_sz:     equ     $ - buf

section     .data

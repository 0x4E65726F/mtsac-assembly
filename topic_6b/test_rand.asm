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
    call    current_time            ; Get current time and store in EAX
    call    srand                   ; seed = EAX
    call    rand                    ; EAX = random number
    mov     ebx, buf                
    mov     ecx, buf_sz
    call    itoa
    mov     ebx, eax
    mov     eax, buf
    call    print_string
    call    endl

    mov     eax, 0
    call    exit

section     .bss
    buf:        resb    2048
    buf_sz:     equ     $ - buf

section     .data
    curVal:     dd      1

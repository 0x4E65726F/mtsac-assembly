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
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for reame

    push    dword str_sz        ; push arg2 the size of the string
    push    str                 ; push arg1 the address of the string
    call    print_string        

    dec     dword [esp + 4]
    call    reverse_string
    inc     eax
    mov     [esp + 4], eax

    call    print_string
    add     esp, 8

    push    val1
    push    val2
    call    swap
    add     esp, 8

break:
    push    dword 0             ; push exit code
    call    exit

section     .bss

section     .data
    array:      dd      

; who: Nero Li, yli342
; what: A program that loads values
;       from mem and adds and substracts
; why: Topic 3 example
; when: 2022-03-17

section     .text

global      _start

_start:
    mov     eax, [val1]         ; move val1 into accumulator
    add     eax, [val2]         ; add to accumulator val2
    sub     eax, [val3]         ; subtract val3 from accumulator
    mov     [final], eax        ; store sum in final 
    mov     ebx, eax            ; copy sum into ebx
    and     ebx, mask           ; isolate least sig bit in ebx
    mov     ebx, [array + 8]    

exit:  
    mov     ebx, 0              ; return 0 status on exit - 'No Errors'
    mov     eax, 1              ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    final   resd    1           ; memory location for sum of values

section     .data
    val1    dd      2001        ; initialize value
    val2    dd      1000        ; initialize value
    val3    dd      4000        ; initialize value
    mask    equ     0000_0000_0000_0000_0000_00000_0000_0001b
    array   dd      -22, 15, 55, 64, 2
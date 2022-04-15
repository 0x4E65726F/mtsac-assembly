; who: Nero Li, yli342
; what: <the function of this program>
; why: <the name of the lab>
; when: 2022-MM-DD

section     .text

global      _start

_start:

read_array:
    mov     ecx, n_sz           ; ecx is counter control
    mov     esi, aName          ; esi holds address of array

    .loop:                      ; Push the chars of aName on the stack
    movzx   ax, byte [esi]      ; get character
    push    ax                  ; push on stack
    inc     esi
    loop    .loop

write_array:
    mov     ecx, n_sz           ; ecx is counter control
    mov     esi, aName          ; esi holds address of array

    .loop:                      ; Pop each char from the stack and store it in aName
    pop     ax                  ; get character
    mov     [esi], al           ; store in string
    inc     esi 
    loop    .loop

print_array:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, aName
    mov     edx, n_sz
    inc     edx
    int     80h

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss

section     .data
    aName:  db  "Abraham Lincoln"
    n_sz:   equ $ - aName
            db  0ah

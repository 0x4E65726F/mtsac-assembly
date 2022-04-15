section     .text

global      _start
extern      print_string

_start:
    mov     eax, name
    mov     ebx, namesz
    call    print_string

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss

section     .data
    name:   db  "Fred Sanford", 0ah
    namesz: equ $ - name
            db  0ah

section     .text
;---------------------------------------------------------------------------------------------
print_string:
;
; Print an array of characters to the console.
; Receives: EAX (address of the array), EBX (size of the array)
; Returns: Nada
; Requires: Nada
;---------------------------------------------------------------------------------------------
    push    ebx
    mov     ecx, eax
    mov     edx, ebx
    mov     eax, 4
    mov     ebx, 1
    int     80h
    pop     ebx
    ret
;---------------------------------------------------------------------------------------------    

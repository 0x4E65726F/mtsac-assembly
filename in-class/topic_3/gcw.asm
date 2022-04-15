; who: Nero Li, yli342
; what: Goodbye cruel world program
; why: Topic 3 coding example
; when: 2022-03-15

section     .text

global      _start

_start:
    mov     eax, 4                              ; system call code for write
    mov     ebx, 1                              ; file descripter for stdout
    mov     ecx, msg                            ; pass address of msg to OS
    mov     edx, len                            ; length of msg (in bytes)
    int     0x80

exit:  
    mov     ebx, 0                              ; return 0 status on exit - 'No Errors'
    mov     eax, 1                              ; invoke SYS_EXIT (kernel opcode 1)
    int     0x80

section     .data
    msg     db  'Goodbye Cruel World!', 0xa      
    len     equ $ - msg                         ; length in bytes of msg

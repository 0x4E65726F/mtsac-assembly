; who: Nero Li, yli342
; what: Write a program to take a string from user input, reverse it, and print it to the console.
; why: Lab 5A
; when: 2022-04-07

section     .text

global      _start

_start:
    mov     eax, prompt                             ; move prompt address into eax
    mov     ebx, plen                               ; move prompt leangth into ebx
    call    print_string                            ; call print_string procedure
    mov     eax, buf                                ; move buffer address into eax
    mov     ebx, bufsz                              ; move buffer size into ebx
    call    get_user_input                          ; call get_user_input
    mov     eax, buf                                ; move buffer address into eax
    mov     ebx, bufsz                              ; move buffer size into ebx
    call    string_reverse                          ; call string_reverse
    mov     eax, buf                                ; move buffer address into eax
    mov     ebx, bufsz                              ; move buffer size into ebx
    call    print_string                            ; call print_string

exit:  
    mov     ebx, 0                                  ; return 0 status on exit - 'No Errors'
    mov     eax, 1                                  ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    buf:    resb    128                             ; input and output buffer
    bufsz:  equ     $ - buf                         ; Length in bytes of buffer

section     .data
    prompt  db  'Enter a string for reverse: '      ; Prompt message for user interface
    plen    equ $ - prompt                          ; Length in bytes of prompt

section     .text

global      _start

;---------------------------------------------------------------------------------------------
get_user_input:
;
; Get users input as an array of characters from the console.
; Receives: EAX (address of the array), EBX (size of the array)
; Returns: Nada
; Requires: Nada
;---------------------------------------------------------------------------------------------
    push    ebx                 ; push ebx into stack   
    mov     ecx, eax            ; address of input buffer
    mov     edx, ebx            ; size of input buffer
    mov     eax, 3              ; read from file
    mov     ebx, 0              ; file descriptor is stdin
    int     80h                 ; syscall
    pop     ebx                 ; pop stack value into ebx
    ret                         ; return procedure
;---------------------------------------------------------------------------------------------    

;---------------------------------------------------------------------------------------------
print_string:
;
; Print an array of characters to the console.
; Receives: EAX (address of the array), EBX (size of the array)
; Returns: Nada
; Requires: Nada
;---------------------------------------------------------------------------------------------
    push    ebx                 ; push ebx into stack   
    mov     ecx, eax            ; address of output buffer
    mov     edx, ebx            ; size of output buffer
    mov     eax, 4              ; write to file
    mov     ebx, 1              ; file descriptor is stdout
    int     80h                 ; syscall
    pop     ebx                 ; pop stack value into ebx 
    ret                         ; return procedure
;---------------------------------------------------------------------------------------------    

;---------------------------------------------------------------------------------------------
string_reverse:
;
; Reverse the array of characters and give them back to original space
; Receives: EAX (address of the array), EBX (size of the array)
; Returns: void
; Requires: none
;---------------------------------------------------------------------------------------------
    mov     esi, eax            ; esi holds address of array
    mov     ecx, ebx            ; ecx is counter control
    dec     ecx                 ; ignore 0ah in array

    ; Push the chars of aName on the stack
    .push_loop:                 
    movzx   ax, byte [esi]      ; get character
    push    ax                  ; push on stack
    inc     esi                 ; increment esi by 1
    loop    .push_loop

    mov     ecx, ebx            ; ecx is counter control
    dec     ecx                 ; ignore 0ah in stack
    sub     esi, ebx            ; move esi address to the beginning of the array

    ; Pop each char from the stack and store it in aName
    .pop_loop:                  
    pop     ax                  ; get character
    mov     [esi], al           ; store in string
    inc     esi                 ; increment esi by 1
    loop    .pop_loop

    mov     al, 0ah             ; Get a new line for reversed string
    mov     [esi], al           ; Add that new line after the reversed string
    ret                         ; return procedure
;---------------------------------------------------------------------------------------------    

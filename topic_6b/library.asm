section     .data
    errMsg:     db      "Error: exit code 1", 0x0A
    err_sz:     equ     $ - errMsg
    endline:    db      0x0A
    seed:       dd      1
    const_a:    equ     1103515245
    const_b:    equ     12345
    const_c:    equ     65536
    const_d:    equ     32768

section     .text

global      print_string
global      endl
global      get_input
global      exit
global 	    reverse_string
global      atoi
global      itoa
global      current_time
global      srand
global      rand
global      legal_string_input

;----------------------------------------------------------------------------------------
print_string:
;
; Prints a string to stdout
; Receives: EAX = address
;           EBX = size of the string
; Returns:  nothing
; Requires: nothing
; Notes:    none
;----------------------------------------------------------------------------------------
    push    ebx                 ; preserve

    mov     ecx, eax            ; copy address of string into ecx for output
    mov     edx, ebx            ; copy size of the string into edx
    mov     eax, 4              ; set for write operation
    mov     ebx, 1              ; file descriptor for stdout
    int     80h                 ; syscall

    pop     ebx                 ; restore
    ret                         ; return procedure
; End print_string ----------------------------------------------------------------------

;----------------------------------------------------------------------------------------
endl:
;
; Print a next line.
; Receives: nothing
; Returns:  nothing
; Requires: nothing
; Notes:    none
;----------------------------------------------------------------------------------------
    push    eax                 ; preserve
    push    ebx                 ; preserve

    mov     eax, 4              ; write to file
    mov     ebx, 1              ; file descriptor is stdout
    mov     ecx, endline        ; the new line character
    mov     edx, 1              ; length is 1
    int     0x80                ; syscall

    pop     ebx                 ; restore
    pop     eax                 ; restore
    ret                         ; return procedure
; End print_string ----------------------------------------------------------------------

;----------------------------------------------------------------------------------------
get_input:
;
; Gets a string from stdin
; Receives: EAX = address of the buffer
;           EBX = size of the buffer
; Returns:  EAX = size of the inpur (number of chars)
; Requires: nothing
; Notes:    none
;----------------------------------------------------------------------------------------
    push    ebx                 ; preserve

    mov     ecx, eax            ; copy address of buffer into ecx for input
    mov     edx, ebx            ; copy size of the buffer into edx
    mov     eax, 3              ; set for read operation
    mov     ebx, 0              ; file descriptor for stdin
    int     80h                 ; syscall

    pop     ebx                 ; restore
    ret                         ; return procedure
; End get_input -------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
exit:  
;
; Terminates the program gracefully
; Receives: EAX = exit code
; Returns:  nothing
; Requires: nothing
; Notes:    none
;----------------------------------------------------------------------------------------
    mov     ebx, eax            ; return status on exit
    mov     eax, 1              ; invoke SYS_EXIT (kernel opcode 1)
    int     80h
; End exit ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
reverse_string:
; 
; Reverse an array of characters
; Receives: EAX (address of the array)
; 			EBX (size of the array)
; Returns: 	Nothing
; Requires:	Nothing
;----------------------------------------------------------------------------------------
	push	esi                 ; preserve
	push 	edi                 ; preserve
	push 	ebx                 ; preserve
	mov 	esi, eax            ; set esi as pointer
	mov 	ecx, ebx            ; set ecx as counter
	mov 	edi, esi            ; store address in edi for write loop
	
read:
	.loop:
	movzx 	dx, byte [esi]      ; mov char into dx
	push 	dx                  ; push char on stack
	inc 	esi                 ; increment pointer
	loop 	.loop
	
write:
	mov 	ecx, ebx            ; reset counter
	.loop:
	pop 	dx                  ; pop char from stack
	mov 	[edi], dl           ; store it in string
	inc 	edi                 ; increment pointer
	loop 	.loop
	
	pop		ebx                 ; restore
	pop 	edi                 ; restore
	pop 	esi                 ; restore
	ret
; End reverse_string --------------------------------------------------------------------

;----------------------------------------------------------------------------------------
atoi:
; 
; COnvert a string representation of an unsigned integer to an integer
; Receives: EAX = the address of the string
; 			EBX = the size of the string
; Returns: 	EAX = the unsigned integer value
; Requires:	Nothing
; Note:     Horner's polynomial method
;           tmp = 0
;           for each char (left to right)
;               tmp = 10 * tmp + (char_val - 48) (converts vhar to digit)
;----------------------------------------------------------------------------------------
    push    esi                 ; preserve
    push    ebx                 ; preserve

    mov     esi, eax            ; esi is pointer to array
    mov     ecx, ebx            ; ecx holds counter (number of chars)
    mov     ebx, 10             ; ebx is const multiplier
    xor     eax, eax            ; eax holds running product (set to 0)

    .loop:
    mul     ebx                 
    movzx   edx, byte [esi]     ; move character into edx
    add     eax, edx            ; char to running product
    sub     eax, 48             ; character to digit constant
    inc     esi                 ; increment pointer
    loop    .loop

    pop     ebx                 ; restore
    pop     esi                 ; restore
    ret
; End atoi ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
itoa:
; 
; Convert aan unsigned integer to a string representation
; Receives: EAX = the integer to be converted
; 			EBX = the address of the string
;           ECX = the size of the string
; Returns: 	EAX = the number of chars added to the string
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebx                 ; preserve
    push    esi                 ; preserve
    push    edi                 ; preserve
    push    dword 0             ; create a counter var

    mov     esi, ebx            ; set esi as pointer
    mov     edi, ebx            ; set edi as pointer
    mov     ebx, 10             ; ebx i divisor

    .loop:
    xor     edx, edx            ; set edx to 0 for division
    idiv    ebx                 ; divide number
    add     edx, 48             ; get character from remainder
    mov     [esi], edx          ; store the character
    inc     dword [esp]         ; increment counter
    cmp     eax, 0              ; eax <=> 0 ?
    je      .break              ; if eax == 0 then break from loop
    inc     esi                 ; increment pointer
    loop    .loop

    .break:
    mov     eax, edi
    mov     ebx, [esp]
    call    reverse_string

    mov     eax, ebx            ; ebx should still hold counter
    add     esp, 4              ; remove counter
    pop     edi                 ; restore
    pop     esi                 ; restore
    pop     ebx                 ; restore
    ret
; End itoa ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
current_time:
; 
; Get and return the current time in seconds since Unix EPOCH (Jan 1, 1970)
; Receives: Nothing
; Returns: 	EAX = integer value for time in secs
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebx          
    mov     eax, 13             ; syscalll number for time
    xor     ebx, ebx            ; time location = NULL
    int     0x80                ; 32-bit time value returned in EAX

    pop     ebx
    ret
; End current_time ----------------------------------------------------------------------

;----------------------------------------------------------------------------------------
srand:
; 
; Set the random number seed
; Receives: EAX = unsigned integer value as seed
; Returns: 	Nothing
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    mov     [seed], eax
    ret
; End srand -----------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
rand:
; 
; Generate a random number
; Receives: Nothing
; Returns: 	EAX = random unsigned integer
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebx                 ; preserve
    push    edx
    mov     eax, [seed]
    mov     ebx, [const_a]
    xor     edx, edx
    mul     ebx
    add     eax, [const_b]
    mov     [seed], eax
    mov     ebx, [const_c]
    xor     edx, edx
    idiv    ebx
    mov     ebx, [const_d]
    xor     edx, edx
    idiv    ebx
    mov     eax, edx
    pop     edx
    pop     ebx
    ret
; End rand ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
legal_string_input:
; 
; Get and return the current time in seconds since Unix EPOCH (Jan 1, 1970)
; Receives: Nothing
; Returns: 	EAX = integer value for time in secs
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    esi                 ; preserve
    push    ebx                 ; preserve
    push    edx

    mov     esi, eax            ; esi is pointer to array
    mov     ecx, ebx            ; ecx holds counter (number of chars)
    mov     ebx, 10             ; ebx is const multiplier
    xor     eax, eax            ; eax holds running product (set to 0)

    .loop:
    mul     ebx                 
    movzx   edx, byte [esi]     ; move character into edx
    cmp     edx, 43
    cmp     edx, 45

    add     eax, edx            ; char to running product
    sub     eax, 48             ; character to digit constant
    inc     esi                 ; increment pointer
    loop    .loop
    jmp     .success

    .err:
    mov     eax, errMsg
    mov     ebx, err_sz
    call    print_string
    mov     eax, 1
    call    exit

    .success:
    pop     edx
    pop     ebx                 ; restore
    pop     esi                 ; restore
    ret
; End current_time ----------------------------------------------------------------------

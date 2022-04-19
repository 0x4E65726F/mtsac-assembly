section     .bss
    isNeg:      resb    1
    numArray:   resb    4
    num_sz:     resd    1

section     .data
    errMsg:     db      "Error: invalid integer input", 0x0A
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
global      pow

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
; Convert a string representation of an unsigned integer to an integer
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
; Convert an unsigned integer to a string representation
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
    push    ecx                 ; preserve
    push    edx                 ; preserve
    xor     eax, eax            ; initalize eax to 0
    xor     ebx, ebx            ; initalize ebx to 0
    xor     ecx, ecx            ; initalize ecx to 0
    xor     edx, edx            ; initalize edx to 0
    mov     eax, [seed]         ; eax = seed
    mov     ebx, const_a        ; ebx = 1103515245
    mul     ebx                 ; eax *= ebx
    add     eax, const_b        ; eax += 12345
    mov     [seed], eax         ; store the new seed number
    xor     ebx, ebx            ; initalize ebx to 0
    mov     ebx, const_c        ; ebx = 65536
    xor     edx, edx            ; initalize edx to 0
    idiv    ebx                 ; eax /= ebx, edx get remainder
    xor     ebx, ebx            ; initalize ebx to 0
    mov     ebx, const_d        ; ebx = 32768
    xor     edx, edx            ; initalize edx to 0
    idiv    ebx                 ; eax /= ebx, edx get remainder
    mov     eax, edx            ; move edx into eax
    pop     edx                 ; restore
    pop     ecx                 ; restore
    pop     ebx                 ; restore
    ret
; End rand ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
get_next:
; 
; Get the character value from ESI and then move ESI to next one
; Receives: ESI = Pointer to character
; Returns: 	AL = the character
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    mov     al, byte [esi]
    inc     esi
    ret
; End get_next --------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
display_error:
; 
; Display the error message
; Receives: Nothing
; Returns: 	Nothing
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    mov     eax, errMsg
    mov     ebx, err_sz
    call    print_string
    ret
; End display_error ---------------------------------------------------------------------

;----------------------------------------------------------------------------------------
is_digit:
; 
; Generate a random number
; Receives: AL = character we need to check
; Returns: 	ZF = Zero Flag
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    cmp     al, '0'             ; ZF = 0
    jb      ID1
    cmp     al, '9'             ; ZF = 0
    ja      ID1
    test    ax, 0               ; ZF = 1
    
    ID1:
    ret
; End is_digit --------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
legal_string_input:
; 
; Get and return the current time in seconds since Unix EPOCH (Jan 1, 1970)
; Receives: EAX = the address of the string
; 			EBX = the size of the string
; Returns: 	EAX = integer value for time in secs
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    esi                 ; preserve
    push    ebx                 ; preserve
    push    edx                 ; preserve

    mov     esi, eax            ; esi is pointer to array
    mov     edi, eax            ; edi is the array for number
    mov     ecx, ebx            ; ecx holds counter (number of chars)
    xor     eax, eax            ; eax holds running product (set to 0)

    .loop:
    
    .state_a:
    call    get_next
    cmp     al, '+'             ; leading plus sign?
    je      .state_b            ; go to State B
    cmp     al, '-'             ; leading minus sign?
    je      .state_b            ; go to State B
    call    is_digit            ; returns ZF = 1 if AL = digit
    jz      .state_c            ; go to State C
    call    display_error       ; invalid input found
    jmp     .exit

    .state_b:
    cmp     ecx, ebx            ; see the character is the first one or not
    je      .continue_b         ; if legal, continue work in state_b
    call    display_error       ; invalid input found
    jmp     .exit
    .continue_b:
    sub     al, '+'             ; subtract al with '+'
    inc     edi                 ; increase one byte in edi for atoi convert
    dec     ebx                 ; decrease one byte in ebx for atoi convert
    mov     byte [isNeg], al    ; move the subtract result into isNeg
    jmp     .state_d

    .state_c:
    .state_d:
    loop    .loop               
    mov     eax, edi            ; move the address edi into eax
    call    atoi
    mov     bl, [isNeg]         ; move isNeg number into bl, it should be either 0 or 2
    cmp     bl, 0               ; check bl if it has been subtracted by '+'
    je      .isPos              ; jump if bl == 0
    neg     eax                 ; change number in eax to negative

    .isPos:
    .exit:
    pop     edx                 ; restore
    pop     ebx                 ; restore
    pop     esi                 ; restore
    ret
; End legal_string_input ----------------------------------------------------------------

;----------------------------------------------------------------------------------------
pow:
; 
; Get and return the current time in seconds since Unix EPOCH (Jan 1, 1970)
; Receives: EAX = the address of the string
; 			EBX = the size of the string
; Returns: 	EAX = integer value for time in secs
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ecx
    push    edx

    push    eax
    xor     edx, edx
    xor     ecx, ecx
    mov     eax, 1
    mov     ecx, 0
    
    .loop:
    cmp     ebx, 0
    je      .exit
    mul     eax
    shl     ebx, 1
    jnc     .not1
         
    .not1:
    loop    .loop

    .exit:
    ret
; End pow -------------------------------------------------------------------------------

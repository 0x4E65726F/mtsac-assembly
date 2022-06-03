section     .bss
    isNeg:      resb    1
    numArray:   resb    4
    num_sz:     resd    1
    temp:       resd    1

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

; basic
global      print_string
global      endl
global      get_input
global      exit
global 	    reverse_string
global      atoi
global      itoa

; random number process
global      current_time
global      srand
global      rand

; check input is legal or not
global      legal_string_input

; power function
global      pow

; two different type of swap
global      swap
global      swap2

; null-terminated string process
global      print_nt_string
global      string_copy
global      atoi_nt
global      get_nt_input
global      to_lower
global 	    to_upper

; dword sort
global      bubble_sort_d
global      bin_search_d

; file process
global      file_open
global      file_create
global      file_close
global      file_read
global      file_write

;----------------------------------------------------------------------------------------
print_string:
;
; Prints an array of characters to the console.
; Receives: arg1: address of the array
;           arg2: size of the array
; Returns:  Nothing
; Requires: Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    
    push    ebx                 ; preserve ebx

    mov     ecx, [ebp + 8]      ; move arg1 into ecx (address of the string)
    mov     edx, [ebp + 12]     ; move arg2 into edx (size of the string)
    mov     eax, 4              ; set stream as stdout
    mov     ebx, 1              ; set write code
    int     80h                 ; syscall

    pop     ebx                 ; restore
    pop     ebp                 ; restore caller's base pointer

    ret                         ; return procedure
; End print_string ----------------------------------------------------------------------

;----------------------------------------------------------------------------------------
endl:
;
; Print a next line.
; Receives: Nothing
; Returns:  Nothing
; Requires: Nothing
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
; Get input of an array of characters from the console
; Receives: arg1: address of the input array
;           arg2: size of the array
; Returns:  EAX (number of characters)
; Requires: Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    
    push    ebx                 ; preserve

    mov     ecx, [ebp + 8]      ; set ecx to arg1
    mov     edx, [ebp + 12]     ; set edx to arg2
    mov     eax, 3              ; set stream as stdin
    mov     ebx, 0              ; set read code
    int     80h                 ; syscall

    pop     ebx                 ; restore
    pop     ebp                 ; restore caller's base pointer
    
    ret                         ; return procedure
; End get_input -------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
exit:  
;
; Exits the program gracefully
; Receives: arg1: exit code
; Returns:  Nothing
; Requires: Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    
    mov     ebx, [ebp + 8]      ; return status on exit
    mov     eax, 1              ; invoke SYS_EXIT (kernel opcode 1)
    int     80h
; End exit ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
reverse_string:
; 
; Reverse an array of characters
; Receives: arg1: address of the array
; 			arg2: size of the array
; Returns: 	Nothing
; Requires:	Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame

	push	esi                 ; preserve
	push 	edi                 ; preserve

	mov 	esi, [ebp + 8]      ; set esi as pointer
	mov 	ecx, [ebp + 12]     ; set ecx as counter
	mov 	edi, esi            ; store address in edi for write loop
	
    .read:
	.loop1:
	movzx 	dx, byte [esi]      ; mov char into dx
	push 	dx                  ; push char on stack
	inc 	esi                 ; increment pointer
	loop 	.loop1
	
    .write:
	mov 	ecx, [ebp + 12]     ; reset counter
	.loop2:
	pop 	dx                  ; pop char from stack
	mov 	[edi], dl           ; store it in string
	inc 	edi                 ; increment pointer
	loop 	.loop2
	
	pop 	edi                 ; restore
	pop 	esi                 ; restore
    pop     ebp                 ; restore caller's base pointer
	ret
; End reverse_string --------------------------------------------------------------------

;----------------------------------------------------------------------------------------
atoi:
; 
; Convert a string representation of an unsigned integer to an integer
; Receives: arg1: the address of the string
; 			arg2: the size of the string
; Returns: 	EAX: the unsigned integer value
; Requires:	Nothing
; Note:     Horner's polynomial method
;           tmp = 0
;           for each char (left to right)
;               tmp = 10 * tmp + (char_val - 48) (converts vhar to digit)
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame

    push    esi                 ; preserve
    push    ebx                 ; preserve

    mov     esi, [ebp + 8]      ; esi is pointer to array
    mov     ecx, [ebp + 12]     ; ecx holds counter (number of chars)
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
    pop     ebp                 ; restore caller's base pointer
    ret
; End atoi ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
itoa:
; 
; Convert an unsigned integer to a string representation
; Receives: arg1: the integer to be converted
; 			arg2: the address of the string
;           arg3: the size of the string
; Returns: 	EAX = the number of chars added to the string
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    sub     esp, 4              ; allocate temp var
    mov     [ebp - 4], dword 0  ; init temp to 0
    
    push    ebx                 ; preserve
    push    ecx                 ; preserve
    push    esi                 ; preserve
    push    edi                 ; preserve
    mov     eax, [ebp + 8]      ; move arg1 into eax for conversion

    mov     esi, [ebp + 12]     ; set esi as pointer
    mov     edi, [ebp + 12]     ; set edi as pointer
    mov     eax, [ebp + 16]     ; move arg3 (array size) into ecx
    mov     ebx, 10             ; ebx i divisor

    .loop:
    xor     edx, edx            ; set edx to 0 for division
    idiv    ebx                 ; divide number
    add     edx, 48             ; get character from remainder
    mov     [esi], edx          ; store the character
    inc     dword [ebp - 4]     ; increment counter
    cmp     eax, 0              ; eax <=> 0 ?
    je      .break              ; if eax == 0 then break from loop
    inc     esi                 ; increment pointer
    loop    .loop

    .break:
    push    dword [ebp - 4]     ; agr2 for rev_str call
    push    edi                 ; arg1 for rev_str call
    call    reverse_string
    add     esp, 8

    mov     eax, [ebp - 4]      ; ebx should still hold counter
    add     esp, 4              ; deallocate temp var
    pop     edi                 ; restore
    pop     esi                 ; restore
    pop     ecx                 ; restore
    pop     ebx                 ; restore

    pop     ebp                 ; restore caller's base pointer
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
; Exponentiation function
; Receives: param1 base (32bit)
; 			param2 exponent (32bit->16bit)
; Returns: 	EDX:EAX = base raised to the exponent
; Requires:	Two arguments on stack
; Note:     Nothing
; Algo:     Square and Multiply
;----------------------------------------------------------------------------------------
    
    push    ebp                 ; preserve
    mov     ebp, esp            ; set base of stack frame

    push    ebx                 ; preserve
    push    edi                 ; preserve
    mov     eax, 1              ; product
    mov     ecx, 16             ; 
    mov     ebx, [ebp + 8]      ; get base (ebx)
    mov     edi, [ebp + 12]     ; get exp  (edi)

.state_1:
    shl     di, 1               ; shift left to inspect msb
    jc      .state_2            ; if msb == 1 transition to state 2
    loop    .state_1            ; get next msb

.state_2:
    pushfd                      ; preserve CF
    mul     eax                 ; square prod
    popfd                       ;
    jnc     .next               ; if not CF then don't multiply
    mul     ebx                 ; 
    .next:
    shl     di, 1
    loop    .state_2

    pop     edi                 ; restore
    pop     ebx                 ; restore
    pop     ebp                 ; restore
    ret
; End pow -------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
swap:
; 
; Swaps the values at two addresses 
; Receives: arg1: address 1
;           arg2: address 2
; Returns: 	Nothing
; Requires: Nothing
;----------------------------------------------------------------------------------------
    
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base of frame
    sub     esp, 4              ; allocate temp var

    mov     eax, [ebp + 8]      ; get address of arg1
    mov     eax, [eax]          ; get val at arg1
    mov     [ebp - 4], eax      ; store val in temp
    mov     eax, [ebp + 12]     ; get address of arg2
    mov     eax, [eax]          ; get val at arg2
    xchg    eax, [ebp - 4]      ; swap values

    mov     edx, [ebp + 12]     ; move address of arg1 into edx
    mov     [edx], eax          ; move into address of arg1 val in eax
    mov     edx, [ebp - 4]      ; move val in temp into edx
    mov     eax, [ebp + 8]      ; move address of arg2 into eax
    mov     [eax], edx          ; move val in edx to address of arg2

    mov     esp, ebp            ; deallocate temp var
    pop     ebp                 ; restore caller's base pointer
    ret

; End swap ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
swap2:
; 
; Swap two values
; Receives: REF x
;           REF y
; Returns: 	Nothing
; Requires:	Nothing
; Note:     Nothing
; Algo:     Nothing
;----------------------------------------------------------------------------------------
    
    push    ebp
    mov     ebp, esp

    push    esi
    push    edi

    lea     esi, [ebp + 12]     ; Store address for REF x
    lea     edi, [ebp + 8]      ; Store address for REF y

    mov     eax, [edi]
    xor     [esi], eax
    mov     eax, [esi]
    xor     [edi], eax
    mov     eax, [edi]
    xor     [esi], eax

    pop     edi
    pop     esi
    leave
    ret
    
; End swap2 -----------------------------------------------------------------------------

; null-terminated string process
;----------------------------------------------------------------------------------------
get_size:
; 
; This displays the size of a string that has been null-terminated.
; Receives: arg1 = the address of a null-terminated string
; Returns: 	EAX = the size of the string (not including the null terminator)
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    push    edi                 ; preserve esi
    push    ecx                 ; preserve ecx

    cld                         ; direction = forward
    mov     edi, [ebp + 8]      ; move arg1 into esi (address of the string)
    mov     ecx, -1             ; size start at -1 to make sure repeat won't end at first
    mov     al, 0               ; check if edi is at the null terminator
    repne   scasb               ; repeat while the null terminator has not been found
    neg     ecx                 ; change ecx from negative to positive
    dec     ecx                 ; decrease -1 that we add at beginning
    mov     eax, ecx            ; move size number into eax

    pop     ecx                 ; restore ecx
    pop     edi                 ; restore esi
    pop     ebp                 ; restore caller's base pointer
    ret
; End get_size ---------------------------------------------------------------------------00000000000000000000000000000000

;----------------------------------------------------------------------------------------
print_nt_string:
; 
; This displays a string that has been null-terminated.
; Receives: arg1 = the address of a null-terminated string
; Returns: 	Nothing
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    push    eax                 ; preserve eax
    push    ebx                 ; preserve ebx
    push    ecx                 ; preserve ecx
    push    edx                 ; preserve edx

    mov     ecx, [ebp + 8]      ; move arg1 into ecx (address of the string)
    push    ecx                 ; push ecx into stack for procedure call
    call    get_size             ; get size of the string
    pop     ecx                 ; get ecx back
    mov     edx, eax            ; move size of the string into edx
    mov     eax, 4              ; set stream as stdout
    mov     ebx, 1              ; set write code
    int     80h                 ; syscall    

    pop     edx                 ; restore edx
    pop     ecx                 ; restore ecx
    pop     ebx                 ; restore ebx
    pop     eax                 ; restore eax
    pop     ebp                 ; restore caller's base pointer
    ret
; End print_string ----------------------------------------------------------------------

;----------------------------------------------------------------------------------------
string_copy:
; 
; Copy a null terminated string from one array into another.
; Receives: arg1 = the address of the source string
;           arg2 = the address of the destination string
; Returns: 	Nothing
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    push    esi                 ; preserve esi
    push    edi                 ; preserve edi
    push    eax                 ; preserve eax
    push    ecx                 ; preserve ecx
    
    cld                         ; direction = forward
    mov     esi, [ebp + 8]      ; move arg1 into esi (address of the source string)
    mov     edi, [ebp + 12]     ; move arg2 into esi (address of the destination string)
    push    esi                 ; push esi into stack for procedure call
    call    get_size             ; get size of the string
    pop     esi                 ; get esi back
    mov     ecx, eax            ; move size of the string into ecx
    inc     ecx                 ; include the null terminator
    rep     movsb               ; copy all characters from source to target

    pop     ecx                 ; restore ecx
    pop     eax                 ; restore eax
    pop     edi                 ; restore edi
    pop     esi                 ; restore esi
    pop     ebp                 ; restore caller's base pointer
    ret
; End string_copy -----------------------------------------------------------------------

;----------------------------------------------------------------------------------------
atoi_nt:
; 
; Convert a string representation of an unsigned integer to an integer
; Receives: arg1: the address of the string
; 			arg2: the size of the string
; Returns: 	EAX: the unsigned integer value
; Requires:	Nothing
; Note:     Horner's polynomial method
;           tmp = 0
;           for each char (left to right)
;               tmp = 10 * tmp + (char_val - 48) (converts vhar to digit)
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame

    push    ebx                 ; preserve

    push    dword [ebp + 8]     ; push address of array
    call    get_size
    add     esp, 4

    push    eax
    push    dword [ebp + 8]
    call    atoi
    add     esp, 8

    pop     ebx                 ; restore
    pop     ebp                 ; restore caller's base pointer
    ret
; End atoi_nt ---------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
get_nt_input:
;
; Get null terminated string from the console
; Receives: arg1: address of the input array
;           arg2: size of the array
; Returns:  EAX (number of characters)
; Requires: Nothing
;----------------------------------------------------------------------------------------
    push    ebp                         ; preserve caller's base pointer
    mov     ebp, esp                    ; set base pointer for frame
    
    push    ebx                         ; preserve

    push    dword [ebp + 12]            ; set arg2
    push    dword [ebp + 8]             ; set arg1
    call    get_input                   ; call get_input
    add     esp, 8                      ; deallocate get_input args

    mov     ebx, [ebp + 8]              ; set ebx = address of input array
    mov     byte [ebx + eax - 1], 0     ; write terminator to address + size - 1

    pop     ebx                         ; restore
    pop     ebp                         ; restore caller's base pointer
    
    ret                                 ; return procedure
; End get_nt_input ----------------------------------------------------------------------

;----------------------------------------------------------------------------------------
to_lower:
; 
; Scan the string for uppercase alphabet characters and convert them to lowercase.
; Receives: arg1 = the address of a null-terminated string
; Returns: 	Nothing
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    push    esi                 ; preserve esi
    push    edi                 ; preserve edi
    push    eax                 ; preserve eax
    push    ecx                 ; preserve ecx

    cld                         ; direction = forward
    mov     esi, [ebp + 8]      ; move arg1 into esi (address of the string)
    mov     edi, esi            ; also move arg1 into edi
    push    esi                 ; push esi into stack for procedure call
    call    get_size             ; get size of the string
    pop     esi                 ; get esi back
    mov     ecx, eax            ; move size of the string into ecx

    .loop:
    lodsb                       ; copy [esi] into al
    cmp     al, 'A'             ; see if al is smaller than 'A'
    jb      .no_change
    cmp     al, 'Z'             ; see if al is bigger than 'Z'
    ja      .no_change
    add     al, 'a' - 'A'       ; change al from upper case to lower case
    .no_change:
    stosb                       ; store al at [edi]
    loop    .loop
    
    pop     ecx                 ; restore ecx
    pop     eax                 ; restore eax
    pop     edi                 ; restore edi
    pop     esi                 ; restore esi
    pop     ebp                 ; restore caller's base pointer
    ret
; End to_lower --------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
to_upper:
; 
; Set the random number seed
; Receives: arg1 = the address of a null-terminated string
; Returns: 	Nothing
; Requires:	Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    push    esi                 ; preserve esi
    push    edi                 ; preserve edi
    push    eax                 ; preserve eax
    push    ecx                 ; preserve ecx
    
    cld                         ; direction = forward
    mov     esi, [ebp + 8]      ; move arg1 into esi (address of the string)
    mov     edi, esi            ; also move arg1 into edi
    push    esi                 ; push esi into stack for procedure call
    call    get_size             ; get size of the string
    pop     esi                 ; get esi back
    mov     ecx, eax            ; move size of the string into ecx

    .loop:
    lodsb                       ; copy [esi] into al
    cmp     al, 'a'             ; see if al is smaller than 'a'
    jb      .no_change
    cmp     al, 'z'             ; see if al is bigger than 'z'
    ja      .no_change
    add     al, 'A' - 'a'       ; change al from lower case to upper case
    .no_change:
    stosb                       ; store al at [edi]
    loop    .loop

    pop     ecx                 ; restore ecx
    pop     eax                 ; restore eax
    pop     edi                 ; restore edi
    pop     esi                 ; restore esi
    pop     ebp                 ; restore caller's base pointer
    ret
; End to_upper --------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
bubble_sort_d:  
;
; Description Bubble sort on array of double words
; Receives: arg1: array address
;           arg2: size of the array
; Returns:  Nothing
; Requires: Nothing
; Note:     Nothing
; Algo:     N = array size, cx1 = outer loop counter, cx2 = inner loop counter
;               cx1 = N - 1
;               while( cx1 > 0 )
;               {
;                   esi = addr(array)
;                   cx2 = cx1
;                   while( cx2 > 0 )
;                   {
;                   if( array[esi] < array[esi+4] )
;                       exchange( array[esi], array[esi+4] )
;                   add esi, 4
;                   dec cx2
;                   }
;               dec cx1
;               }
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    push    esi                 ; preserve esi

    mov     ecx, [ebp + 12]     ; move array size into ecx
    shr     ecx, 2              ; get qty of elements from qty bytes

    dec     ecx                 ; decrement count by 1

    .outerloop:
    push    ecx                 ; save outer loop count
    mov     esi, [ebp + 8]      ; move array address into esi

    .innerloop:
    mov     eax, [esi]          ; get array value
    cmp     [esi + 4], eax      ; compare a pair of values
    jge     .skip               ; if [esi] <= [edi], skip
    xchg    eax, [esi + 4]      ; else exchange the pair
    mov     [esi], eax

    .skip:
    add     esi, 4              ; increment pointer
    loop    .innerloop          ; inner loop

    pop     ecx                 ; retrive outer loop count
    loop    .outerloop          ; outer loop

    pop     esi                 ; restore esi
    pop     ebp                 ; restore caller's base pointer
    ret

; End bubble_sort_d ---------------------------------------------------------------------

;----------------------------------------------------------------------------------------
bin_search_d:  
;
; Description Use binary search to search sorted array
; Receives: arg1: array address
;           arg2: size of the array
;           arg3: search term
; Returns:  eax: address of found value or -1
; Requires: Nothing
; Notes:    Nothing
; Algo:     algorithm
;               int bin_search( int values[], int count, const int searchVal )
;               {
;                   int first = 0;
;                   int last = count - 1;
;                   while( first <= last )
;                   {
;                       int mid = (last + first) / 2;
;                       if( values[mid] < searchVal )
;                           first = mid + 1;
;                       else if( values[mid] > searchVal )
;                           last = mid - 1;
;                       else
;                           return mid; // success
;                   }
;                   return -1; // not found
;               }
;----------------------------------------------------------------------------------------

    push    ebp                     ; preserve caller's base pointer
    mov     ebp, esp                ; set base pointer for frame
    push    esi                     ; preserve esi
    push    edi                     ; preserve edi
    push    ebx                     ; preserve ebx (used for mid offset)

    mov     eax, -1                 ; set default value of eax
    mov     edx, [ebp + 16]         ; store search term in edx

    mov     esi, [ebp + 8]          ; set esi = first
    mov     edi, [ebp + 12]         ; set edi = size
    lea     edi, [esi + edi - 4]    ; set edi = effective address of last

    .while: 
    cmp     esi, edi                ; compare esi, edi
    jg      .wend                   ; if esi > edi then exit loop

    mov     ebx, edi                ; find address of mid
    sub     ebx, esi                ; dif in doubleword
    shr     ebx, 3                  ; doubleword to byte and div by 2
    shl     ebx, 2                  ; mul to doubleword

    cmp     [esi + ebx], edx        ; ? array[mid] == search term ?
    jne     .skip                   ; if not equal then skip
    lea     eax, [esi + ebx]        ; set return value = mid
    jmp     .wend

    .skip:
    cmp     [esi + ebx], edx
    jg      .greater                ; if array[mid] > term then go to greater
    lea     esi, [esi + ebx + 4]    ; else array[mid] < term so first = mid + 1
    jmp     .while                  ; loop

    .greater:                       ; array[mid] > term
    lea     edi, [esi + ebx - 4]    ; last = mid - 1
    jmp     .while                  ; loop

    .wend:
    pop     ebx                     ; restore ebx
    pop     edi                     ; restore edi
    pop     esi                     ; restore esi
    pop     ebp                     ; restore caller's base pointer
    ret

; End bin_search_d ---------------------------------------------------------------------

;----------------------------------------------------------------------------------------
file_open:  
;
; Description: Open a file for read
; Receives: arg1: file path
; Returns:  EAX = descriptor
; Requires: Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    
    mov     eax, 5              ; call sys_open
    mov     ebx, [ebp + 8]      ; file path
    mov     ecx, 0              ; access mode (read only)
    mov     edx, 777o           ; perm
    int     80h
    
    pop     ebp                 ; restore caller's base pointer
    ret

; End file_open_read --------------------------------------------------------------------

;----------------------------------------------------------------------------------------
file_create:  
;
; Description: Create a file for write
; Receives: arg1: file path
; Returns:  EAX = descriptor
; Requires: Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    
    mov     eax, 8              ; call sys_creat
    mov     ebx, [ebp + 8]      ; file path
    mov     ecx, 777o           ; perm
    int     80h
    
    pop     ebp                 ; restore caller's base pointer
    ret

; End file_open_write -------------------------------------------------------------------

;----------------------------------------------------------------------------------------
file_close:  
;
; Description: Close a file
; Receives: arg1: file descriptor
; Returns:  Nothing
; Requires: Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    
    mov     eax, 6              ; call sys_close
    mov     ebx, [ebp + 8]      ; file descriptor
    int     80h             
    
    pop     ebp                 ; restore caller's base pointer
    ret

; End file_close ------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
file_read:  
;
; Description: Read a file
; Receives: arg1: file descriptor
;           arg2: buffer address
;           arg3: buffer size
; Returns:  EAX = quantity of bytes read
; Requires: Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    
    mov     eax, 3              ; call sys_read
    mov     ebx, [ebp + 8]      ; file descriptor
    mov     ecx, [ebp + 12]     ; buffer
    mov     edx, [ebp + 16]     ; buffer size
    int     80h
    
    pop     ebp                 ; restore caller's base pointer
    ret

; End file_read -------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
file_write:  
;
; Description: Write data into file
; Receives: arg1: file descriptor
;           arg2: buffer address
;           arg3: byte size
; Returns:  Nothing
; Requires: Nothing
; Note:     Nothing
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    
    mov     eax, 4              ; call sys_write
    mov     ebx, [ebp + 8]      ; file descriptor
    mov     ecx, [ebp + 12]     ; buffer
    mov     edx, [ebp + 16]     ; byte size
    int     80h
    
    pop     ebp                 ; restore caller's base pointer
    ret

; End file_write ------------------------------------------------------------------------
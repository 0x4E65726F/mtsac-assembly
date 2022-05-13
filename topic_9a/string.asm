; who: Nero Li, yli342
; what: File with all of the string procedures implemented
; why: Lab 9a: String Procedures
; when: 2022-05-18

section     .text

global      size_of
global      print_string
global      string_copy
global      to_lower
global 	    to_upper

;----------------------------------------------------------------------------------------
size_of:
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
; End size_of ---------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
print_string:
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
    call    size_of             ; get size of the string
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
    call    size_of             ; get size of the string
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
    call    size_of             ; get size of the string
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
    call    size_of             ; get size of the string
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

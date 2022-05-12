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
    push    esi                 ; preserve esi

    mov     esi, [ebp + 8]      ; move arg1 into esi (address of the string)
    mov     eax, 0              ; size number start at zero

    .loop:
    cmp     [esi], byte 0       ; check if esi is at the null terminator
    je      .end
    inc     eax                 ; one character found, ++size
    inc     esi                 ; check the next character
    jmp     .loop

    .end:
    pop     esi                 ; restore esi
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

    

    pop     ebp                 ; restore caller's base pointer
    ret
; End to_upper --------------------------------------------------------------------------

%include "student_contact.inc"

array_sz:   equ     24
TRUE:       equ     1
FALSE:      equ     0

section     .text

global      _start

_start:
    push    ebp             ; preserve ebp
    mov     ebp, esp        ; establish base pointer
    push    word 0          ; local var initalized to 0
    sub     esp, (array_sz * student_contact_size)


    push    dword 0         ; push exitcode
    call    exit            ; call exit

section     .text
    ; get_student - load a single student
    ;               returns false if no student was entered or true otherwise
;----------------------------------------------------------------------------------------
get_student:
; 
; Gets an individual student
; Receives: arg1 = address of the memory to store the student
; Returns: 	EAX = true if the student was entered or false otherwise
; Requires:	student_contact, TRUE, FALSE
; Note:     Nothing
; Algo:     Nothing
;----------------------------------------------------------------------------------------
    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; set base pointer for frame
    push    edi                 ; preserve edi 
    mov     edi, [ebp + 8]      ; address of the student record
    mov     eax, FALSE          ; 
    
    ; prompt for name
    push    dword name_sz       ; arg2 = size
    lea     esi, [edi + student_contact.name]
    push    edi
    call    get_nt_input
    add     esp, 8

    cmp     eax, 0              ; If size of name is zero, return false
    je      .return

    ; prompt for id
    push    dword id_sz
    lea     esi, [edi + student_contact.id]
    push    edi
    call    get_nt_input
    add     esp, 8

    ; prompt for address
    push    dword address_sz
    lea     esi, [edi + student_contact.address]
    push    edi
    call    get_nt_input
    add     esp, 8

    ; prompt for city
    push    dword city_sz
    lea     esi, [edi + student_contact.city]
    push    edi
    call    get_nt_input
    add     esp, 8

    ; prompt for state
    push    dword state_sz
    lea     esi, [edi + student_contact.state]
    push    edi
    call    get_nt_input
    add     esp, 8

    ; prompt for zip
    push    dword zip_str_sz
    push    zip_str
    call    get_nt_input
    add     esp, 8

    push    zip_str
    call    atoi_nt
    add     esp, 4
    lea     edi, [edi + student_contact.zip]
    mov     [edi], ax

    mov     eax, TRUE
    .return:
    pop     edi
    pop     ebp                 ; restore caller's base pointer
    ret



section     .bss
    zip_str:        resb    10
    zip_str_sz:     equ     $ - zip_str
; End get_student -----------------------------------------------------------------------
    ; get_students - calls getstudent repeatedly 
    ;                stops when user enters empty string for name

%include    "main.inc"

section     .text

global      _start

_start:
    mov     esi, source     ; move source string address into esi
    mov     edi, dest       ; move destination string address into edi

    push    esi             ; push arg1
    call    print_nt_string
    pop     esi             ; pop arg1

    push    edi             ; push arg2
    push    esi             ; push arg1
    call    string_copy
    pop     esi             ; pop arg1
    pop     edi             ; pop arg2

    push    edi             ; push arg1
    call    print_nt_string
    call    to_upper
    call    print_nt_string
    call    to_lower
    call    print_nt_string
    pop     edi             ; pop arg1

    push    dword 0
    call    exit

section     .bss
    dest:       resb    20      

section     .data
    source:     db      "Hello world!", 0Ah, 0

; _start:
;     call    current_time
;     call    srand
;     call    rand
;     push    buffer_sz
;     push    buffer
;     push    eax
;     call    itoa
;     add     esp, 12

;     push    eax
;     push    buffer
;     call    print_nt_string
;     add     esp, 8
;     call    endl
    
;     call    rand
;     push    buffer_sz
;     push    buffer
;     push    eax
;     call    itoa
;     add     esp, 12

;     push    eax
;     push    buffer
;     call    print_nt_string
;     add     esp, 8
;     call    endl

;     push    array_sz
;     push    array
;     call    bubble_sort_d

;     pop     eax
;     pop     eax
;     push    dword [search_3]
;     push    array_sz
;     push    array
;     call    bin_search_d
;     mov     ebx, [eax]

;     push    buffer_sz
;     push    buffer
;     push    ebx
;     call    itoa
;     add     esp, 12

;     push    eax
;     push    buffer
;     call    print_nt_string
;     add     esp, 8
;     call    endl

;     pop     eax
;     pop     eax
;     pop     eax
;     push    dword [search_5]
;     push    array_sz
;     push    array
;     call    bin_search_d
;     mov     ebx, [eax]

;     push    buffer_sz
;     push    buffer
;     push    ebx
;     call    itoa
;     add     esp, 12

;     push    eax
;     push    buffer
;     call    print_nt_string
;     add     esp, 8
;     call    endl

;     pop     eax
;     pop     eax
;     pop     eax
;     push    dword [search_7]
;     push    array_sz
;     push    array
;     call    bin_search_d
;     mov     ebx, [eax]

;     push    buffer_sz
;     push    buffer
;     push    ebx
;     call    itoa_nt
;     add     esp, 12

;     push    buffer
;     call    print_nt_string
;     add     esp, 4
;     call    endl

;     push    buffer_sz
;     push    buffer
;     push    dword 12345
;     call    itoa_nt
;     add     esp, 12

;     push    buffer
;     call    print_nt_string
;     add     esp, 4
;     call    endl

;     push    dword 0
;     call    exit

; section     .bss     
;     buffer:     resb    512
;     buffer_sz:  equ     $ - buffer

; section     .data
;     array:      dd      1, 3, 2, 5, 4, 8, 9, 6, 7, 0
;     array_sz:   equ     $ - array
;     search_3:   dd      3
;     search_5:   dd      5
;     search_7:   dd      4
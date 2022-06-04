%include    "main.inc"

section     .text

global      _start

_start:
    call    current_time
    call    srand
    call    rand
    push    buffer_sz
    push    buffer
    push    eax
    call    itoa
    add     esp, 12

    push    eax
    push    buffer
    call    print_string
    add     esp, 8
    
    call    current_time
    call    srand
    call    rand
    push    buffer_sz
    push    buffer
    push    eax
    call    itoa
    add     esp, 12

    push    eax
    push    buffer
    call    print_string
    add     esp, 8

    push    array_sz
    push    array
    call    bubble_sort_d

    pop     eax
    pop     eax
    push    dword [search_3]
    push    array_sz
    push    array
    call    bin_search_d
    mov     ebx, [eax]

    push    buffer_sz
    push    buffer
    push    ebx
    call    itoa
    add     esp, 12

    push    eax
    push    buffer
    call    print_string
    add     esp, 8

    pop     eax
    pop     eax
    pop     eax
    push    dword [search_5]
    push    array_sz
    push    array
    call    bin_search_d
    mov     ebx, [eax]

    push    buffer_sz
    push    buffer
    push    ebx
    call    itoa
    add     esp, 12

    push    eax
    push    buffer
    call    print_string
    add     esp, 8

    pop     eax
    pop     eax
    pop     eax
    push    dword [search_7]
    push    array_sz
    push    array
    call    bin_search_d
    mov     ebx, [eax]

    push    buffer_sz
    push    buffer
    push    ebx
    call    itoa
    add     esp, 12

    push    eax
    push    buffer
    call    print_string
    add     esp, 8

exit:  
    mov     ebx, 0      ; return 0 status on exit - 'No Errors'
    mov     eax, 1      ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss     
    buffer:     resb    1024
    buffer_sz:  equ     $ - buffer

section     .data
    array:      dd      1, 3, 2, 5, 4, 8, 9, 6, 7, 0
    array_sz:   equ     $ - array
    search_3:   dd      3
    search_5:   dd      5
    search_7:   dd      4
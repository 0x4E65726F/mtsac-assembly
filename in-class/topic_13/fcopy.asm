extern      print_nt_string
extern      get_nt_input
extern      exit

section     .text

global      _start

_start:
    push    ebp
    mov     ebp, esp
    sub     esp, 8

    ; prompt for source path
    push    src_prompt
    call    print_nt_string
    add     esp, 4

    ; get file path
    push    dword path_sz
    push    path
    call    get_nt_input
    add     esp, 8

    ; open src file
    mov     eax, 5
    mov     ebx, path
    mov     ecx, 0
    mov     edx, 777o
    int     80h

    ; store src descriptor on var1
    mov     [ebp - 4], eax

    ; prompt for destination path
    push    dst_prompt
    call    print_nt_string
    add     esp, 4

    ; get file path
    push    dword path_sz
    push    path
    call    get_nt_input
    add     esp, 8

    ; create dst file
    mov     eax, 8
    mov     ebx, path
    mov     ecx, 777o
    int     80h
    mov     [ebp - 8], eax

    .while:
    mov     eax, 3
    mov     ebx, [ebp - 4]
    mov     ecx, buffer
    mov     edx, buf_sz
    int     80h

    cmp     eax, 0
    je      .wend

    mov     edx, eax
    mov     eax, 4
    mov     ebx, [ebp - 8]
    mov     ecx, buffer
    int     80h

    jmp     .while

    .wend:
    ; close files
    mov     eax, 6
    mov     ebx, [ebp - 4]
    int     80h

    mov     eax, 6
    mov     ebx, [ebp - 8]
    int     80h

    add     esp, 8
    pop     ebp
    push    dword 0
    call    exit

section     .bss
    buffer:         resb    8196
    buf_sz:         equ     $ - buffer
    path:           resb    50
    path_sz:        equ     $ - path

section     .data
    src_prompt:     db      "Enter the path of the source file: ", 0
    dst_prompt:     db      "Enter the path of the destination file: ", 0
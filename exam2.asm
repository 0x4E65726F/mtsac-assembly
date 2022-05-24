arraySearch:
    push    ebp                 ; preserve
    mov     ebp, esp            ; start frame
    push    dword 0             ; create a init local var i
    push    esi                 ; preserve 
    mov     esi, [ebp + 8]      ; array
    mov     ecx, [ebp + 12]     ; count
    mov     edx, [ebp + 16]     ; term
    mov     eax, -1

    .while:
    cmp     edx, [esi]
    je      .wend
    inc     [ebp - 4]
    add     esi, 4
    loop    .while

    .wend:
    mov     eax, [ebp - 4]

    .return:
    pop     esi
    add     esp, 4
    pop     ebp
    ret

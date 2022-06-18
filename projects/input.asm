get_input:
    mov     eax, 3      ; read from file
    mov     ebx, 0      ; file descriptor is stdin
    mov     ecx, ibuf   ; address of input buffer
    mov     edx, ibuf_sz; size of input buffer
    int     0x80        ; syscall  --  returns size of input on eax
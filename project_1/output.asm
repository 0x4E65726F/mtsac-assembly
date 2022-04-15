output:
    mov     eax, 4      ; write to file
    mov     ebx, 1      ; file descriptor is stdout
    mov     ecx, prompt ; address of the ouput string
    mov     edx, plen   ; length of the string
    int     0x80        ; syscall
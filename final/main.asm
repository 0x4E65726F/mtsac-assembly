%include    "main.inc"

section     .text

global      _start

_start:
    push    ebp                                 ; set frame start
    mov     ebp, esp                            
    push    dword 0                             ; head = null (0)

    mov     eax, 0x2d                           ; syscall alloc heap space
    xor     ebx, ebx                            ; ebx = 0 (get current program brk)
    int     0x80


    mov     dword [eax + node.val], 5           ; store value in struc
    mov     edx, [ebp - 4]                      ; edx = head
    mov     dword [eax + node.next], edx        ; next = edx
    mov     [ebp - 4], eax                      ; head = new node

    mov     eax, 0x2d                           ; syscall alloc heap space
    lea     ebx, [eax + node_size]              ; change address of the heap
    int     0x80

    add     esp, 4
    pop     ebp
    
    push    dword 0
    call    exit

section     .bss

section     .data

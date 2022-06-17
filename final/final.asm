; who: Nero Li, yli342
; what: Encrypt and Decrypt Rewind
; why: lab_final
; when: 2022-06-17
%include    "final.inc"

section     .text

global      _start

_start:
    ; open files
    call    open_files

    ; get rand seed
    call    set_seed
    ; process the file
    call    process_files

    ; close files
    call    close_files

    ; exit
    push        dword 0
    call        exit

section     .bss
in_fd:      resd    1
out_fd:     resd    1
buff_sz:    equ     16384
buff:       resb    buff_sz

section     .data
in_fprompt:     db      "Please enter the path of the input file:", 0
out_fprompt:    db      "Please enter the path of the output file:", 0
seed_prompt:    db      "Please enter the key (0 - 4294967295): ", 0

section     .text

;----------------------------------------------------------------------------------------
open_files:  
;
; Description open the input and output files
; Receives: Nothing
; Returns:  Nothing
; Requires: None
; Notes:    None
; Algo:     None
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame

    ; get in filename
    push    in_fprompt
    call    print_nt_string
    push    buff_sz
    push    buff
    call    get_nt_input

    ; open the in file
    push    dword 0
    push    buff
    call    file_open
    mov     [in_fd], eax

    ; get out filename
    push    out_fprompt
    call    print_nt_string
    push    buff_sz
    push    buff
    call    get_nt_input

    ; open the out file
    push    buff
    call    file_create
    mov     [out_fd], eax
    
    leave                       ; move esp ebp, pop ebp
    ret

; End open_files ------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
set_seed:  
;
; Description prompt user for seed and seed rand
; Receives: Nothing
; Returns:  Nothing
; Requires: None
; Notes:    None
; Algo:     None
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame

    ; get seed from user
    push    seed_prompt
    call    print_nt_string
    push    buff_sz
    push    buff
    call    get_nt_input

    ; convert to uint
    push    buff
    call    atoi_nt
    push    eax
    call    srand

    leave
    ret

; End set_seed --------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
process_files:  
;
; Description read from in, xor with rand, write to out
; Receives: Nothing
; Returns:  Nothing
; Requires: None
; Notes:    None
; Algo:     None
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame

    .while:                     ; while in not eof
    ; read a buffer load from in
    push    buff_sz
    push    buff
    push    dword [in_fd]
    call    file_read
    add     esp, 12
    
    cmp     eax, 0              ; if 0 bytes were read, exit loop
    je      .wend

    ; xor with rand
    push    eax
    call    process_buffer
    pop     eax

    ; write it to out
    push    eax                 ; push arg3
    push    buff                ; push arg2
    push    dword [out_fd]
    call    file_write
    add     esp, 12
    jmp     .while
    
    .wend:
    mov     esp, ebp
    pop     ebp
    ret

; End process_files ---------------------------------------------------------------------

;----------------------------------------------------------------------------------------
process_buffer:  
;
; Description xor buffer contents with rand values
; Receives: arg1: qty of bytes
; Returns:  Nothing
; Requires: None
; Notes:    None
; Algo:     None
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    push    edi

    mov     edi, buffer
    mov     ecx, [ebp + 8]

    .loop:
    call    rand
    xor     [edi], al
    inc     edi
    
    loop    .loop
    
    pop     edi
    pop     ebp
    ret

; End process_buffer --------------------------------------------------------------------

;----------------------------------------------------------------------------------------
close_files:  
;
; Description prompt user for seed and seed rand
; Receives: Nothing
; Returns:  Nothing
; Requires: None
; Notes:    None
; Algo:     None
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    
    ; close in file
    push    dword [in_fd]
    call    file_close

    ; close out file
    push    dword [out_fd]
    call    file_close

    leave
    ret

; End close_files -----------------------------------------------------------------------

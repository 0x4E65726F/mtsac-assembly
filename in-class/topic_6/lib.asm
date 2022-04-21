global      rand
global      srand
global      RAND_MAX

section     .text
;----------------------------------------------------------------------------------------
rand:
; 
; Generates a random 32bit unsigned integer
; Receives: Nothing
; Returns: 	EAX = unsigned 32bit random integer
; Requires:	Memory location called next (unsigned 32 val)
; Note:     Nothing
; Algo:     int rand()
;               next = next * 1103515245 + 12345
;               return next / 65536 % 32768
;----------------------------------------------------------------------------------------
    
    mov     eax, [next]
    mov     ecx, const_1
    mul     ecx
    add     eax, const_2
    mov     [next], eax

    xor     edx, edx
    mov     ecx, const_3
    div     ecx
    mov     ecx, const_4
    div     ecx

    mov     eax, edx
    
    ret

; End rand ------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------
srand:
; 
; Seed rand
; Receives: EAX = unsigned 32bit integer
; Returns: 	Nothing
; Requires:	Memory location called next (unsigned 32 val)
; Note:     Nothing
;----------------------------------------------------------------------------------------
    
    mov     [next], eax

    ret

; End srand -----------------------------------------------------------------------------

section     .data
    next:       dd      1
    const_1:    equ     1103515245
    const_2:    equ     12345
    const_3:    equ     65536
    const_4:    equ     32768
    RAND_MAX:   equ     const_4 - 1
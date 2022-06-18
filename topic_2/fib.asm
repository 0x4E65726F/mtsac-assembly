; who: Nero Li, yli342
; what: <masked>
; why: <masked>
; when: <masked>

section .text

global      _start

_start:

output_prompt:
    mov     eax, 4                                          ; write to file
    mov     ebx, 1                                          ; file descriptor is stdout
    mov     ecx, prompt                                     ; address of the ouput string
    mov     edx, plen                                       ; length of the string
    int     0x80                                            ; syscall
    
get_input:
    mov     eax, 3                                          ; read from file
    mov     ebx, 0                                          ; file descriptor is stdin
    mov     ecx, ibuf                                       ; address of input buffer
    mov     edx, ibuf_sz                                    ; size of input buffer
    int     0x80                                            ; syscall  --  returns size of input on eax

string_to_int:
    dec     eax                                             ; decrease eax of 1 to ignore \n
    mov     ecx, eax                                        ; move the size of input string into ecx
    mov     eax, 0                                          ; set eax into zero for fibLen
    mov     [fibLen], eax                                   ; move the eax number into fibLen
    mov     eax, 1                                          ; move first digit place value into eax

    .loop:
    mov     bl, [ibuf + ecx - 1]                            ; get the first digit from input buffer
    sub     ebx, 48                                         ; change character number into integer
    mov     [tmp], eax                                      ; store current eax value into tmp
    mul     ebx                                             ; do eax *= ebx to get the value we need to add onto fibLen
    add     [fibLen], eax                                   ; add eax value into fibLen
    mov     eax, [tmp]                                      ; get the value back from tmp
    mov     ebx, 10                                         ; move 10 into ebx for multiply
    mul     ebx                                             ; do eax *= ebx in order to add one more digit for next loop
    loop    .loop

calc_fib:
    mov     ecx, [fibLen]                                   ; set the LOOP value
    mov     esi, fib                                        ; move fibonacci address into esi

    .loop:
    mov     eax, [prv]                                      ; $eax = prv
    mov     [esi], eax                                      ; fib[i] = $eax = prv
    add     esi, 4                                          ; change address to fib[i + 1]
    mov     eax, [nxt]                                      ; $eax = nxt
    mov     [tmp], eax                                      ; tmp = $eax= nxt
    add     eax, [prv]                                      ; $eax = nxt + prv
    mov     [nxt], eax                                      ; nxt = $eax = nxt + prv
    mov     eax, [tmp]                                      ; $eax = tmp
    mov     [prv], eax                                      ; prv = $eax = tmp
    loop    .loop                                           ; keep looping until $ecx = 0

get_output:
    mov     edx, 10                                         ; move 10 into edx, this is the character '\n'
    push    edx                                             ; push '\n' into stack
    mov     ecx, [fibLen]                                   ; move fibonacci length into ecx as our beginning loop counter
    mov     esi, fib                                        ; move the fibonacci sequence address into esi

    .push_loop:
    mov     [loop_c], ecx                                   ; temporary store the loop counter in ecx
    mov     eax, [esi + (ecx * 4) - 4]                      ; move the least most value into eax based on ecx value
    mov     edx, 32                                         ; move 32 into edx, this is the character '\0'
    push    edx                                             ; push '\0' into stack
    mov     ecx, [stk_c]                                    ; move stack counter into ecx
    inc     ecx                                             ; increase ecx 1
    mov     [stk_c], ecx                                    ; move ecx value back to stack counter

    .push_dig:
    xor     edx, edx                                        ; set edx to 0
    mov     ebx, 10                                         ; move 10 into ebx
    idiv    ebx                                             ; do edx = eax % ebx and eax /= ebx
    add     edx, 48                                         ; change number into character
    push    edx                                             ; push number character into stack
    mov     ecx, [stk_c]                                    ; move stack counter into ecx
    inc     ecx                                             ; increase ecx 1
    mov     [stk_c], ecx                                    ; move ecx value back to stack counter
    cmp     eax, 0                                          ; compare eax with 0
    jne     .push_dig                                       ; if eax != 0, jump to the beginning of the loop_for_reverse

    mov     ecx, [loop_c]                                   ; move loop counter back to ecx
    loop    .push_loop                                      ; keep loop until ecx = 0

    mov     ecx, [stk_c]                                    ; move stack counter into ecx, this is our pop loop counter
    mov     esi, obuf                                       ; move output buffer address into esi
    .pop_loop:
    mov     [stk_c], ecx                                    ; temporary store the loop counter in ecx
    mov     ecx, [cur_o]                                    ; get current out buffer index into ecx
    pop     edx                                             ; pop value from stack and store into edx
    mov     [esi + ecx], dl                                 ; use dl to move one byte character value into obuf[i]
    inc     ecx                                             ; increase ecx 1
    mov     [cur_o], ecx                                    ; store out buffer index 
    mov     ecx, [stk_c]                                    ; move loop counter back to ecx
    loop    .pop_loop                                       ; keep loop until ecx = 0

output_fib_sequence:
    mov     eax, 4                                          ; write to file
    mov     ebx, 1                                          ; file descriptor is stdout
    mov     ecx, obuf                                       ; address of the ouput string
    mov     edx, obuf_sz                                    ; length of the string
    int     0x80                                            ; syscall

exit:  
    mov     ebx, 0                                          ; return 0 status on exit - 'No Errors'
    mov     eax, 1                                          ; invoke SYS_EXIT (kernel opcode 1)
    int     80h

section     .bss
    fib     resd    30                                      ; uninitalized fibonacci sequence
    ibuf    resb    3                                       ; uninitalized input buffer
    obuf    resb    128                                     ; uninitalized output buffer
    ibuf_sz equ     $ - ibuf                                ; Length in bytes of input buffer
    obuf_sz equ     $ - obuf                                ; Length in bytes of output buffer
    tmp     resd    1                                       ; uninitalized int tmp
    fibLen  resd    1                                       ; uninitalized total loop we need to go

section     .data
    prv     dd  0                                           ; Set int prv = 0
    nxt     dd  1                                           ; Set int nxt = 1
    prompt  db  'Enter a value between 1 and 30: '          ; Prompt message for user interface
    plen    equ $ - prompt                                  ; Length in bytes of prompt
    cur_o   dd  0                                           ; output buffer cursor initally point at index 0
    stk_c   dd  1                                           ; stack counter, inital 1 is for '\n'
    loop_c  dd  0                                           ; loop counter
                                 
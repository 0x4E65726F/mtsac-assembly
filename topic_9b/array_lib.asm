section .text

global  bubble_sort_d
global  bin_search_d

;----------------------------------------------------------------------------------------
bubble_sort_d:  
;
; Description Bubble sort on array of double words
; Receives: arg1: array address
;           arg2: size of the array
; Returns:  Nothing
; Requires: Nothing
; Note:     Nothing
; Algo:     N = array size, cx1 = outer loop counter, cx2 = inner loop counter
;               cx1 = N - 1
;               while( cx1 > 0 )
;               {
;                   esi = addr(array)
;                   cx2 = cx1
;                   while( cx2 > 0 )
;                   {
;                   if( array[esi] < array[esi+4] )
;                       exchange( array[esi], array[esi+4] )
;                   add esi, 4
;                   dec cx2
;                   }
;               dec cx1
;               }
;----------------------------------------------------------------------------------------

    push    ebp                 ; preserve caller's base pointer
    mov     ebp, esp            ; start frame
    push    esi                 ; preserve esi

    mov     ecx, [ebp + 12]     ; move array size into ecx
    shr     ecx, 2              ; get qty of elements from qty bytes

    dec     ecx                 ; decrement count by 1

    .outerloop:
    push    ecx                 ; save outer loop count
    mov     esi, [ebp + 8]      ; move array address into esi

    .innerloop:
    mov     eax, [esi]          ; get array value
    cmp     [esi + 4], eax      ; compare a pair of values
    jge     .skip               ; if [esi] <= [edi], skip
    xchg    eax, [esi + 4]      ; else exchange the pair
    mov     [esi], eax

    .skip:
    add     esi, 4              ; increment pointer
    loop    .innerloop          ; inner loop

    pop     ecx                 ; retrive outer loop count
    loop    .outerloop          ; outer loop

    pop     esi                 ; restore esi
    pop     ebp                 ; restore caller's base pointer
    ret

; End bubble_sort_d ---------------------------------------------------------------------

;----------------------------------------------------------------------------------------
bin_search_d:  
;
; Description Use binary search to search sorted array
; Receives: arg1: array address
;           arg2: size of the array
;           arg3: search term
; Returns:  eax: address of found value or -1
; Requires: Nothing
; Notes:    Nothing
; Algo:     algorithm
;               int bin_search( int values[], int count, const int searchVal )
;               {
;                   int first = 0;
;                   int last = count - 1;
;                   while( first <= last )
;                   {
;                       int mid = (last + first) / 2;
;                       if( values[mid] < searchVal )
;                           first = mid + 1;
;                       else if( values[mid] > searchVal )
;                           last = mid - 1;
;                       else
;                           return mid; // success
;                   }
;                   return -1; // not found
;               }
;----------------------------------------------------------------------------------------

    push    ebp                     ; preserve caller's base pointer
    mov     ebp, esp                ; set base pointer for frame
    push    esi                     ; preserve esi
    push    edi                     ; preserve edi
    push    ebx                     ; preserve ebx (used for mid offset)

    mov     eax, -1                 ; set default value of eax
    mov     edx, [ebp + 16]         ; store search term in edx

    mov     esi, [ebp + 8]          ; set esi = first
    mov     edi, [ebp + 12]         ; set edi = size
    lea     edi, [esi + edi]    ; set edi = effective address of last

    .while: 
    cmp     esi, edi                ; compare esi, edi
    jg      .wend                   ; if esi > edi then exit loop

    mov     ebx, edi                ; find address of mid
    sub     ebx, esi                ; dif in bytes
    shr     ebx, 3                  ; doubleword align
    shl     ebx, 1                  ; mul by 2

    cmp     [esi + ebx], edx        ; ? array[mid] == search term ?
    jne     .skip                   ; if not equal then skip
    lea     eax, [esi + edx]        ; set return value = mid
    jmp     .wend

    .skip:
    cmp     [esi + ebx], edx
    jg      .greater                ; if array[mid] > term then go to greater
    lea     edi, [esi + ebx - 4]    ; else array[mid] < term so last = mid - 1
    jmp     .while                  ; loop

    .greater:                       ; array[mid] > term
    lea     esi, [esi + ebx + 4]
    jmp     .while                  ; loop

    .wend:
    pop     ebx                     ; restore ebx
    pop     edi                     ; restore edi
    pop     esi                     ; restore esi
    pop     ebp                     ; restore caller's base pointer
    ret

; End bin_search_d ---------------------------------------------------------------------
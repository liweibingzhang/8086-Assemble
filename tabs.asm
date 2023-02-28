;--------------------------------------------------------------------
;   Program:  Tabs (MASM version)
;
;   Function: You will write a program named TABS. 
;   It will read lines from an ASCII input text file which is redirected to standard input. 
;   It will perform some simple text editing on the lines, 
;   and write the updated lines to an ASCII output text file which is redirected from the standard output. 
;   The specific editing function is to expand tab characters 
;   (replace each tab with the correct number of spaces) to arrange the output into columns at particular tab stops.
;
;   Owner:    Qizheng Jin
;
;   Date:     Changes
;   02/27/23  original version
;
;---------------------------------------
         .model     small              ;64k code and 64k data
         .8086                         ;only allow 8086 instructions
         .stack     256                ;reserve 256 bytes for the stack
;---------------------------------------



;---------------------------------------
         .data                         ;start the data segment
;---------------------------------------
    read db 100, 0   ; buffer to hold user input
    res db 100, 0    ; buffer to hold result
    tab_num db 0     ; number of tabs
    cnt dw 0         ; number of characters before a tab
    read_cnt dw 0    ; index of current character in read buffer
    res_cnt dw 0     ; index of current character in res buffer
    temp_res dw 0    ; temporary index of current character in res buffer

;---------------------------------------
         .code                         ;start the code segment
;---------------------------------------

;---------------------------------------
;start the code segment
;---------------------------------------
main proc
    ; initialize data segment
    mov ax, @data  ; Load the value of the special symbol @data into the AX register.
    mov ds, ax     ; Move the value in the AX register into the DS register.

; read in tab number
    mov ah, 0Ah    ; indicate that we want to read a number.
    lea dx, tab_num ; Load the memory address of the variable tab_num into the DX register.
    int 21h        ; Call DOS interrupt 21h with function code 0Ah to read a string from the user.

; read in string
    mov ah, 0Ah    ; indicate that we want to read another string.
    lea dx, read   ; Load the memory address of the variable read into the DX register.
    int 21h        ; Call DOS interrupt 21h with function code 0Ah to read a string from the user.

; loop through each character in read
    mov cx, 100             ; the number of iterations for our loop.
    lea si, read            ; Load the memory address of the variable read into the SI register, which will be our source index.
    lea di, res             ; Load the memory address of the variable res into the DI register, which will be our destination index.
    mov bx, 0               ; Load the value 0 into the BX register, which will be our loop counter.
    mov cnt, bx             ; Copy the value of BX into the variable cnt.
    mov read_cnt, bx        ; Copy the value of BX into the variable read_cnt.
    mov res_cnt, bx         ; Copy the value of BX into the variable res_cnt.
    mov temp_res, bx        ; Copy the value of BX into the variable temp_res.

;---------------------------------------
; print the result into the res
;---------------------------------------    
for_loop:
    cmp byte ptr [si+bx], 0 ; check for end of string
    je end_loop             ; If the value at the memory location pointed to by SI+BX is 0 (which indicates the end of the string), jump to the label "end_loop".

; check if current character is not a tab
    cmp byte ptr [si+bx], 09h ; If the value at the memory location pointed to by SI+BX is equal to the tab character (09h), jump to the label "handle_tab".
    je handle_tab

; copy character from read to res
    mov al, [si+bx]         ; Load the value at the memory location pointed to by SI+BX into the AL register.
    mov [di+bx], al         ; Store the value in the AL register at the memory location pointed to by DI+BX.

; increment counters
    inc cnt             ; Increment the value of the variable cnt by 1.
    inc res_cnt         ; Increment the value of the variable res_cnt by 1.
    inc read_cnt        ; Increment the value of the variable read_cnt by 1.
    jmp for_loop        ; Jump back to the label "for_loop" to continue looping through the characters in the string.

;---------------------------------------
; deal with the tab 
;---------------------------------------    
handle_tab:
; save current res count in temporary variable
    mov ax, res_cnt   ; Load the value of res_cnt into the AX register.
    mov temp_res,ax   ; Store the value in the AX register in the variable temp_res.

; add spaces for remaining tabs
    mov dx, cnt       ; Move the value of the nt into the DX register.
    mov al, tab_num   ; Move the value of the tab_num into the AL register.
    sub al, dl        ; Subtract the value in the DL register from the value in the AL register and store the result in the AL register.
    jle skip_spaces   ; If the result in the AL register is less than or equal to zero, jump to the label "skip_spaces".

    mov cx, dx        ; If we get here, move the value in the DX register into the CX register.
    mov al, ' '       ; Load the value for a space character into the AL register.
    add res_cnt, dx   ; Add the value in the DX register to the value of the variable res_cnt.
    loop add_spaces   ; Loop through the next instruction (add_spaces) CX number of times, which will add spaces to the res string.

;---------------------------------------
; reset the character count
;---------------------------------------
skip_spaces:
    mov bx, 0    ; Move the value 0 into the BX register.
    mov cnt, bx  ; Set the value of the variable cnt to 0.

; move past tab character
    inc read_cnt  ; Increment the value of the variable read_cnt by 1 to move past the tab character that was just handled.
    jmp for_loop  ; Jump back to the label "for_loop" to continue looping through the characters in the string.

;---------------------------------------
; add spaces to the result
;---------------------------------------
add_spaces:
    ; add space to res buffer
    mov bx, res_cnt   ; Move the value of the res_cnt into the BX register.
    add bx, di        ; Add the value of the DI register to the value in the BX register to get the memory location to store the space character.
    mov [bx], al      ; Store the ASCII value for a space character at the memory location determined by the BX register.
    inc res_cnt       ; Increment the value of the variable res_cnt by 1.
    loop add_spaces   ; Loop through the next instruction (add_spaces) CX number of times, which will add spaces to the res string.

;---------------------------------------
; print out the result
;---------------------------------------    
end_loop:
    ; print out result
    lea dx, res   ; Load the address of the res string into the DX register using the "lea" instruction.
    mov ah, 09h   ; Set the value of the AH register to 09h to indicate we want to print a string using the DOS "print string" function.
    int 21h       ; Call the DOS interrupt 21h to print out the string in the DX register.

; terminate program
    mov ah, 4Ch   ; Set the value of the AH register to 4Ch to indicate we want to exit the program.
    int 21h       ; Call the DOS interrupt 21h to terminate the program.

    
main endp
end main
;---------------------------------------

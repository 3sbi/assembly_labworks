.386
 .model flat, stdcall
 option casemap :none
 include \masm32\include\windows.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib
 .data
A DW 0,-1,-1,0,-2,0 ;array of 2-byte elements
B DW 6 dup (?)
k_neg DB 0
k_pos DB 0
k_zeros DB 0
header db "programm result",0
sfc db "number of positive numbers equals %.1li",0
sResult db 50 dup (?)
no_n_msg db "there is no negative elements",0
no_z_msg db "there is no zero elements",0
no_p_msg db "there is no positive elements",0
 .code
start:  XOR ESI, ESI
        MOV ECX, 6 ;moves to register length of an array
for_loop:   MOV AX, A[ESI]
            CMP AX, 0
            JZ zero
            JG pos
            INC k_neg
            MOV B[ESI], "N-"
            JMP next
zero:   INC k_zeros
        MOV B[ESI], "Z-"
        JMP next
pos:    INC k_pos
        MOV B[ESI], "P-"
next:   INC ESI
        INC ESI ;ESI increses twice because elements are 2-byte length
LOOP for_loop
invoke wsprintf, ADDR sResult, ADDR sfc, k_pos
pusha ;saves values of all registers before calling the function
    push 0
    push offset header
    push offset sResult
    push 0
    call MessageBox
popa restores values of registers after returning to the main program
CMP k_neg, 0
JNZ negative
invoke MessageBox, NULL, ADDR no_n_msg, addr header, MB_OK
negative:
    CMP k_zeros, 0
    JNZ zeros
invoke MessageBox, NULL, ADDR no_z_msg, addr header, MB_OK
zeros:
    CMP k_pos, 0
    JNZ STOP
pusha  
    push 0
    push offset header
    push offset no_p_msg
    push 0
    call MessageBox
popa
STOP:
    push 0
    call ExitProcess
end start 
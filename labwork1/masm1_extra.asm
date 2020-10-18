.386
 .model flat, stdcall
 option casemap :none
 include \masm32\include\windows.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib
 .data
MEM1 db "1" 
str1 db "Результат", 0
str2 db "Переменная является цифрой", 0
str3 db "Переменная является заглавной латинской буквой", 0
str4 db "Переменная является строчной латинской буквой", 0
 .code
start:
MOV AL, MEM1
AND AL, 11110000b
CMP AL, 00110000b
JZ ZERO
MOV AL, MEM1
JG GR
JL STOP  

ZERO:
    invoke MessageBox, NULL, addr str2, addr str1, MB_OK
    JMP STOP
GR: 
    CMP AL, 40h
    JA FIN 
    JB STOP
FIN: 
    CMP AL, 5Bh
    JB VV
    JA LO
LO:
    CMP AL, 60h
    JA BB
    JB STOP
BB:
    CMP AL, 7Bh
    JB FF
    jmp STOP
FF:
    invoke MessageBox, NULL, addr str4, addr str1, MB_OK
    jmp STOP
VV:
    invoke MessageBox, NULL, addr str3, addr str1, MB_OK
    JMP STOP
STOP: invoke ExitProcess, NULL
end start 
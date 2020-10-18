.586 
 .xmm 
 .model flat, stdcall
 option casemap :none
 include \masm32\include\windows.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 include \masm32\include\debug.inc
 includelib \masm32\lib\debug.lib
 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib
 .data
vect1 dd 18567464.567, 2.8797060, 0.00008, 497877453.0, 559573462527.0, 69595745252.0, 79449383625.0, 89483271541.0
len equ 4 ; digit capacity
bcd0 db 4 dup(0)
bcd2 db 4 dup(0)
bcd3 db 4 dup(0)
sum db 5 dup(0)
subs db 5 dup(0)
neg_msg db the reduced is less than the deducted$"
 .code
start:
movaps XMM0, vect1 ; copies to vector register ХММ0 memory of 128 bit size,
; starting from vect1 adress
movaps XMM1, vect1+16 ; copies to ХММ1 memory size of 128 bit, starting from adress vect1+16
orps XMM0, XMM1
movss bcd0, XMM0 ;на месте 0-ого элемента нулевой элемент
SHUFPS XMM2, XMM0,10010100b
SHUFPS XMM2, XMM0,00111110b
movaps XMM0, XMM2 ;на месте 0-ого элемента первый элемент
SHUFPS XMM2, XMM0,10010100b
SHUFPS XMM2, XMM0,00111110b
movaps XMM0, XMM2 ;на месте 0-ого элемента второй элемент
movss bcd2, XMM0
SHUFPS XMM2, XMM0,10010100b
SHUFPS XMM2, XMM0,00111110b
movaps XMM0, XMM2 ;на месте 0-ого элемента третий элемент
movss bcd3, XMM0
xor esi, esi ; обнуление bx
mov ecx, len 
sum_loop: 
    mov AL, bcd2[esi] 
    adc AL, bcd3[esi]
    AAA
    mov sum[esi], AL
    inc esi
LOOP sum_loop
adc sum[esi],0
xor esi, esi ; zeroing bx
mov cx, len
dec_loop:
    mov AL, sum[esi]
    sbb AL, bcd0[esi]
    aas
    mov subs[esi], AL
    inc esi
LOOP dec_loop
jc m2
jmp exit
m2: lea dx, neg_msg ;print message   
    mov ax,0900h   
    int 21h
exit:
    mov ax,4C00h; DOS function to exit program
    int 21h; exiting program
end start
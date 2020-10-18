.586 ;директива использования системы команд процессора Intel.586
 .xmm ;директива использования технологии xmm
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
len equ 4 ; разрядность числа
bcd0 db 4 dup(0)
bcd2 db 4 dup(0)
bcd3 db 4 dup(0)
sum db 5 dup(0)
subs db 5 dup(0)
neg_msg db "уменьшаемое меньше вычитаемого$"
 .code
start:
movaps XMM0, vect1 ; копирование в векторный регистр ХММ0 содержимого памяти, размером 128 бит (16 Байт),
; начиная с адреса vect1, данные интерпретируются как коды ЧПЗ одинарной точности (SP)
movaps XMM1, vect1+16 ; копирование в ХММ1 четырёх ЧПЗ(SP) 16 Байт памяти, начиная с адреса vect1+16
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
adc sum[esi],0 ;учитываем возможность переноса при сложении цифр из самых старшихразрядов чисел
xor esi, esi ; обнуление bx
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
m2: lea dx, neg_msg ;вывод сообщения   
    mov ax,0900h   
    int 21h
exit:
    mov ax,4C00h; DOS функция выхода из программы
    int 21h; Выход из программы
end start ; окончание программы
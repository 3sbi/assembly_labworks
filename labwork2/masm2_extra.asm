.386
 .model flat, stdcall
 option casemap :none
 include \masm32\include\windows.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib
 .data
A DW 2, 12, -1, 0, 20, 0 ;массив 2байтовых элементов
k_even DW 0 ;количество четных чисел
k_odd DW 0 ;количество нечетных чисел
k_zeros DW 0 ;количество нулей
sum_pos DW 0 ;сумма положительных элементов
sum_neg DW 0 ;сумма отрицательных элементов
header db "programm result",0
seven db "Количество четных элементов = %d",0
sdc db "количество нулей = %d",0
sodd db "количество нечетных = %d",0
B DW 5 dup (?) ;массив B для занесения в него результатов
sResult db 50 dup (0)
 .code
start:  XOR ESI, ESI ;обнуляем ESI
        MOV ECX, 6 ;заносим в регистр-счетчик размер массива
        XOR BX, BX
        XOR DX, DX
for_loop:   
            MOV AX, A[ESI] ;пересылка значения ESIтого элемента массива в AX 
            CMP AX, 0 ; сравниваем с нулем
            JZ zero ; если =0, то переходим по метке zero
            JG pos
            ADD BX, AX ;прибавляем к имеющейся сумме новый элемент, который лежит в AX
odd_test:
            TEST AX, 1
            JZ m_even ;переход на метку even, если четное
                      ;иначе идем просто дальше
            INC k_odd ;k_odd=k_odd+1 
            JMP next ;переход на метку next
zero:   
        INC k_zeros ;k_zeros=k_zeros+1
        JMP next
pos:    
        ADD DX, AX
        JMP odd_test 
m_even:   
        INC k_even ;k_even=k_even+1
next:   INC ESI
        INC ESI ;ESI увеличивается дважды, так как массив A - массив 2байтных элементов
LOOP for_loop ; если счетчик = 0, то цикл заканчивается, иначе - переходим обратно на метку for_loop
XOR ESI, ESI
MOV sum_neg, BX
MOV B[ESI], BX 
ADD ESI, 2
MOV B[ESI], DX
ADD ESI, 2
MOV BX, k_zeros
MOV B[ESI], BX
ADD ESI, 2
MOV BX, k_even
MOV B[ESI], BX
ADD ESI, 2
MOV BX, k_odd
MOV B[ESI], BX
invoke wsprintf, ADDR sResult, ADDR sodd, k_odd
invoke MessageBox, NULL, addr sResult, addr header, MB_OK
invoke wsprintf, ADDR sResult, ADDR sdc, k_zeros
invoke MessageBox, NULL, addr sResult, addr header, MB_OK
invoke wsprintf, ADDR sResult, ADDR seven, k_even
invoke MessageBox, NULL, addr sResult, addr header, MB_OK
invoke ExitProcess, NULL
end start 
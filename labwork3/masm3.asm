.386
 .model flat, stdcall
 option casemap :none
 include \masm32\include\windows.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib
 .data
A DD -10.03 ;определ€ет переменную размером в 1 байт
 .code
start: 
    FLD A    ;занесение в вершину стека ST0 числа ј из пам€ти
    FXTRACT  ;выделение мантиссы (в ST0) и пор€дка (в ST1)
    CMP A, 0 ;сравнение числа дл€ определени€ его знака
    JL LESS  ;если меньше, то в знаковую переменную заноситс€ 1 
    FLD 0    ;иначе - в знаковую заноситс€ 0
    JMP STOP ;Ѕезусловный переход на метку STOP.
LESS: FLD 1
STOP: invoke ExitProcess, NULL ;¬ызов процедуры, завершающей работу программы
end start ; онец программы
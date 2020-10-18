.data
var1: .word 0xffff0000
var2: .word 0x0000ffff #если поменять 0x0000fff0 на 0x0000ffff, то выведет true
msg1: .asciiz "True, all bits are 1\n"
msg2: .asciiz "False, not all of them are 1\n"
.text
	la $t1, var1 #заносим адрес в $t1
	lw $t1, 0($t1) #заносим значение, которое лежало по адресу в $t1
	la $t2, var2
	lw $t2, 0($t2)
	or $t0, $t1, $t2 #применяем логическое или над двумя числами
	beq $t0, 0xffffffff, not_all #сравниваем с числом, содержащим все единичные биты
	la $a0, msg2
	li $v0, 4
	j print
not_all:
	li $v0, 4
	la $a0, msg1
print: 	syscall

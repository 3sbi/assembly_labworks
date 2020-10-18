.data
var1: .word 0xffff0000
var2: .word 0x0000ffff #changing 0x0000fff0 to 0x0000ffff will cause true result
msg1: .asciiz "True, all bits are 1\n"
msg2: .asciiz "False, not all of them are 1\n"
.text
	la $t1, var1 #load adress of var1 to $t1
	lw $t1, 0($t1) #load value of var1
	la $t2, var2
	lw $t2, 0($t2)
	or $t0, $t1, $t2 #bitwise OR, result sets in $t0
	beq $t0, 0xffffffff, all #branches to all if result at $t0 doesnot have zeros 
	la $a0, msg2
	li $v0, 4
	j print
all:
	li $v0, 4
	la $a0, msg1
print: 	syscall

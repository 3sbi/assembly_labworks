.data
arrayA: .word  2 13 0 0 3 5
arrayB: .space 10 # 5 элементов, в каждом элементе 2 символа по 1 байта каждый символ, 5*2*1 = 10
size: .word 6 
msg_even: .asciiz "Number of even elements:"
msg_odd: .asciiz "\nNumber of odd elements:"
msg_zeros: .asciiz "\nNumber of zeros:"
.text
	la $t0, arrayA # loads base adress of arrayA into register $t0
	la $t4, size #load adress of size variable
	lw $t4, 0($t4) #load array size in the same register, $t6 = 6
loop: 
	lw $t2, 0($t0) # get value from array A[i] into register $t2
	beqz $t2, zeros #branches if value of $t2 equals 0
	bgtz $t2, pos
	add $t9, $t9, $t2
even_or_odd:
	li $v0, 2
	div $t2, $v0
	mfhi $t3
	beqz $t3, even
	addi $t5, $t5, 1
	j next_el
zeros:	addi $t7, $t7, 1 #k_zeros = $t4
	j next_el
pos:	add $t8, $t8, $t2
	j even_or_odd
even:	addi $t6, $t6, 1
next_el:addi $t4, $t4, -1 # decrement loop counter
 	addi $t0, $t0, 4 # increment index [i] of arrayA (add the element length, 4 bytes for СwordТ type)
 	bgtz $t4, loop # repeat if not finished yet (Branch to loop label's address if $t6 is greater than zero)
	#занесение в arrayB
	la $t0, arrayB
	sb $t9, 0($t0) #заносим сумму отрицательных элементов
	addi $t1, $t1, 1
	sb $t8, 0($t0) #заносим сумму положительных элементов
	addi $t1, $t1, 1
	sb $t7, 0($t0) #заносим число нулевых элементов
	addi $t1, $t1, 1
	sb $t6, 0($t0) #заносим число четных элементов
	addi $t1, $t1, 1
	sb $t5, 0($t0) #заносим число нечетных элементов
	addi $t1, $t1, 1
	#вывод сообщений
	li $v0, 4 # specify Print string service
 	la $a0, msg_even # load address of print heading
 	syscall # print heading
 	add $a0, $t6, $zero
 	li $v0, 1 # specify Print integer service
 	syscall 
 	li $v0, 4
 	la $a0, msg_odd 
 	syscall 
 	add $a0, $t5, $zero
 	li $v0, 1
 	syscall 
	li $v0, 4
 	la $a0, msg_zeros
 	syscall 
 	add $a0, $t7, $zero
 	li $v0, 1
 	syscall 
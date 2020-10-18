.data
arrayA: .word  -5 42 5 -6 -1 3
arrayB: .space 12 # 6 элементов, в каждом элементе 2 символа по 1 байта каждый символ, 6*2*4 = 48
size: .word 6 
no_neg_msg: .asciiz "There is no negative elements\n"
no_zeros_msg: .asciiz "There is no zero elements\n"
no_pos_msg:  .asciiz "There is no positive elements\n"
msg: .asciiz "Number of positive elements: "
.text
	la $t0, arrayA # loads base adress of arrayA into register $t0
	la $t1, arrayB # $t1 = base adress of arrayB
	la $t6, size #load adress of size variable
	lw $t6, 0($t6) #load array size in the same register, $t6 = 6
	li $t7, 'P'
	li $t8, 'Z'
	li $t9, 'N'
loop: 
	lw $t2, 0($t0) # get value from array A[i] into register $t2
	beqz $t2, zeros #branches if value of $t2 equals 0
	bgt $t2, 0, pos #branches if value of $t2 is greater that 0, otherwise it goes to neg root
	addi $t3, $t3, 1 #k_neg = $t3
	sb $t9, 0($t1)
	addi $t1, $t1, 1
	li $t2, '-'
	sb $t2, 0($t1)
	
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	jal s_func
	add $t1, $zero, $a0
	j m_next
s_func:
	lw $a0,  0($sp) 
	addi $a0, $a0, 1
	addi $sp, $sp, 4
	jr $ra
m_next:	
	li $t2, '-'
	j next_el

	
zeros:	addi $t4, $t4, 1 #k_zeros = $t4
	sb $t8, 0($t1)
	addi $t1, $t1, 1
	li $t2, '-'
	sb $t2, 0($t1)
	addi $t1, $t1, 1
	j next_el
pos:	addi $t5, $t5, 1 #k_pos = $t5
	sb $t7, 0($t1)
	addi $t1, $t1, 1
	li $t2, '-'
	sb $t2, 0($t1)
	addi $t1, $t1, 1
	j next_el
next_el:addi $t6, $t6, -1 # decrement loop counter
 	addi $t0, $t0, 4 # increment index [i] of arrayA (add the element length, 4 bytes for ‘word’ type)
 	bgtz $t6, loop # repeat if not finished yet (Branch to loop label's address if $t6 is greater than zero)
	
	li $v0, 4 # specify Print string service
	bnez $t3, neg_exists
	la $a0, no_neg_msg # load address of print heading
	syscall
neg_exists:
	bnez $t4, zeros_exits
	la $a0, no_zeros_msg # load address of print heading
	syscall
zeros_exits:
	bnez $t5, pos_exists
	la $a0, no_pos_msg
	syscall
pos_exists:
 	la $a0, msg # load address of print heading
 	syscall # print heading
 	add $a0, $t5, $zero
 	li $v0, 1 # specify Print integer service
 	syscall 

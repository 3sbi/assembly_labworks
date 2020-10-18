# Algorithm written on C++:
#
#   uint32_t  t1, t2;               // unsigned 32-bit intermediate values
#   t1 = a + 0x06666666;
#   t2 = t1 ^ b;                   // sum without carry propagation
#   t1 = t1 + b;                   // provisional sum
#   t2 = t1 ^ t2;                  // all the binary carry bits
#   t2 = ~t2 & 0x11111110;         // just the BCD carry bits
#   t2 = (t2 >> 2) | (t2 >> 3);    // correction
#   uint32_t  sum = t1 - t2;       // corrected BCD sum


# bcd1 - bcd2 + bcd3

.data
	bcd1: .word 0x97
	bcd2: .word 0x12
	bcd3: .word 0x9
	minus_sign: .asciiz "-"
	
.text
	lw $a0, bcd1
	lw $a1, bcd2
	jal sub_bcd
		
	move $a0, $v0
	lw $a1, bcd3
		
	jal sum_bcd
	j end
	
	sub_bcd:
		# $a0 - $a1
		
		move $s0, $ra # save return position
		move $s1, $a0 # save first (positive) argument
		move $a0, $a1

		# To subtract two numbers, 10's complement addition should be used. 
		# To compute the 10's complement of a number, subtract it digit-by-digit from 99999999 (decimal) and then add 1
		li $t2, 0xF9999999
		sub $a0, $t2, $a0 
		li $a1, 0x00000001
		jal sum_bcd 
		
		move $a0, $v0
		move $a1, $s1 # restore saved argument
		jal sum_bcd 
		jr $s0

	sum_bcd:
		# $a0 + $a1
   	addi $t1,$a0,0x06666666 #t1 = a + 0x06666666;
   	xor $t2,$t1,$a1     #t2 = t1 ^ b;   // sum without carry propagation
   	addu $t1,$t1,$a1    #t1 = t1 + b;   // provisional sum
   	xor $t2,$t1,$t2     #t2 = t1 ^ t2;  // all the binary carry bits

   	add $t3,$zero,-1        #load -1 into help-register
   	xor $t2, $t2,$t3    #actual not-operation
   	add $t4,$zero,0x11111110 #loading 0x11111110 into help-register
   	and $t2,$t2,$t4     #t2 = ~t2 & 0x11111110;//just the BCD carry bits

   	add $t3,$zero,$zero #reseting $t3
   	add $t4,$zero,$zero #reseting $t4

   	srl $t3,$t2,2       #(t2 >> 2)
   	srl $t4,$t2,3       #(t2 >> 3)
   	or $t2,$t3,$t4      #(t2 >> 2) | (t2 >> 3)
   	sub $v0,$t1,$t2     #t2 = (t2 >> 2) | (t2 >> 3)// correction
   	jr $ra
    
 end:
  move $a1, $v0
 	bgez $a1, result
	li $t2, 0xF9999999
	sub $a1, $t2, $a1
	addi $a1, $a1, 0x00000001
	la $a0, minus_sign
	li $v0, 4 # string mode
	syscall
 
 	result:
 	move $a0, $a1
 	li $v0, 34 # set hex printing mode
 	syscall 

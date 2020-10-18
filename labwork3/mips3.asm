.data
	varAA: .float -10.03
	log: .float 0.3010299956
	one: .float 1.0
	s_output: .asciiz "S = "
.text
	l.s $f1, log
	l.s $f2, one
	l.s $f3, varAA
	add.s $f1, $f1, $f2 # $f1 = log + 1
	mul.s $f12, $f1, $f3 # $f1 = (log + 1) * A
	li $v0, 4 # specify Print string service
	la $a0, s_output # load address of print heading
	syscall # outputs "S = "
 	li $v0, 2 # specify Print integer service
 	syscall # outputs value of SS variable
 
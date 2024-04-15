.data
check_exit: .asciiz "exit"
.text
	la $s6,check_exit
	addi $s6,$s6,1
	lb $a0,0($s6)
	li $v0,11
	syscall
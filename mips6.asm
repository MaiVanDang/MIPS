.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display is already to do
# Auto clear after sw
.data
check_exit: .asciiz "exit"
.text
	li $k0, KEY_CODE
	li $k1, KEY_READY
	li $s0, DISPLAY_CODE
	li $s1, DISPLAY_READY
	li $s2,' '
	li $s3, '\n' 
loop: 
	li $sp,0x7fffeffc
WaitForKey: 
	lw $t1, 0($k1) # $t1 = [$k1] = KEY_READY
	nop
	beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
	nop 
#-----------------------------------------------------
ReadKey: 
	lw $t0, 0($k0) # $t0 = [$k0] = KEY_CODE
	sw $t0,0($sp)
	beq $t0,$s2,Encrypt
	beq $t0,$s3,Encrypt
	addi $sp,$sp,4
	j	WaitForKey
	nop
#-----------------------------------------------------
#WaitForDis: 
#	lw $t2, 0($s1) # $t2 = [$s1] = DISPLAY_READY
#	nop
#	beq $t2, $zero, WaitForDis # if $t2 == 0 then Polling
#	nop
#-----------------------------------------------------
Encrypt: #Mã hóa
	jal check
	li $sp,0x7fffeffc
print:	
	lw $t0,0($sp)
	
	add $sp,$sp,4
#-----------------------------------------------------
ShowKey: 
	sw $t0, 0($s0) # show key
	beq $t0,$s2,loop
	beq $t0,$s3,loop
	nop
#-----------------------------------------------------
	j print 
	nop
check:
	li $s4,0
	li $sp,0x7fffeffc
	la $s6,check_exit
	li $s5,0
loop2:
	beq $s5,4,exit_or_continue
	addi $s5,$s5,1
	lw $t0,0($sp)
	lbu $s7,0($s6)
	addi $sp,$sp,4
	addi $s6,$s6,1
	bne $t0,$s7,loop2 
plus:
	addi $s4,$s4,1
	j	loop2
exit_or_continue:
	beq $s4,4,end
	jr $ra
end:
	li $v0,10
	syscall
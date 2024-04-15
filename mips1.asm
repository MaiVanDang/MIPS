.eqv SEVENSEG_LEFT 0xFFFF0011 # Dia chi cua den led 7 doan trai.
# Bit 0 = doan a;
# Bit 1 = doan b; ...
# Bit 7 = dau .
.eqv SEVENSEG_RIGHT 0xFFFF0010 # Dia chi cua den led 7 doan phai
.eqv SEVENSEG_RIGHT 0xFFFF0010 
.data
segment_data1: .word 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67
segment_data2: .word 0x77, 0x7c, 0x58, 0x5e, 0x79, 0x71
.text
main:
	la $s1,segment_data1
	li $s2,0
loop1:	
	beq $s2,10,loop2
	lw $a0,0($s1)
	li $t0, SEVENSEG_LEFT # assign port's address
	sb $a0, 0($t0) # assign new value
	addi $s1,$s1,4
	addi $s2,$s2,1
	j loop1
loop2:
	li $a0,0x80
	li $t0, SEVENSEG_LEFT # assign port's address
	sb $a0, 0($t0)
	
	la $s1,segment_data2
	li $s2,0
loop3:
	beq $s2,6,return
	lw $a0,0($s1)
	li $t0, SEVENSEG_RIGHT # assign port's address
	sb $a0, 0($t0) # assign new value
	addi $s1,$s1,4
	addi $s2,$s2,1
	j loop3
return:
.data 
space: .asciiz  " "
line: .asciiz "\n"
A: .word 1, 8, 2, 4, 5, 9, 7, 3, 6
Aend: .word
.text
main:
	la $a0,A  #$a0 = Address(A[0])
	li $s1,9	# so luong cac phan tu
	j 	sort
print:
	li $t0,0
	add $v0,$a0,$zero
	sw $t1,0($v0)
	li $v0,1
	move $a0,$t1
	syscall
	add $v0,$v0,4
	addi $t0,$t0,1
	beq $t0,$s1,after_sort
	j	print
after_sort: 
	li $v0, 10 #exit
	syscall
end_main:
#----------------------------------------------	
sort:
	li $t0,0 		# n =0
	add $v0,$a0,$zero 	# $v0 = Address(A[n])
	addi $v1,$v0,0		#$v1 = Address(A[n])
	li $t1,0 		#i=0
loop:	
	addi $t1,$t1,1		# i = i+1
	seq $t5,$t1,$s1		#if i = n goto sort
	seq $t6,$t0,$zero	#khong con su hoan doi
	and $t5,$t5,$t6
	bne $t5,$zero,after_sort	# neu thoa man ca 2 dieu kien tren thi goto after_sort
	seq $t5,$t1,$s1		#if i = n goto sort
	sne $t6,$t0,$zero	#da co su hoan doi
	and $t5,$t5,$t6
	bne $t5,$zero,sort
	add $v0,$v1,$zero	#$v0 = Address(A[n]) 
	add $v1,$v1,4		# $v1 = Address(A[n+1])
	lw $t2,0($v0)		#$t2=A[n]
	lw $t3,0($v1)		#$t3=A[n+1]
	sgt $t4,$t2,$t3 	#if A[n] > A[n+1] goto swat
	bne $t4,$zero, swat
	j	loop
swat:
	sw $t3,0($v0)		#A[n]=A[n+1]
	sw $t2,0($v1)		#A[n+1]=A[n]
	addi $t0,$t0,1 		#n=n+1
	j	loop
#---------------------------------------------------------------


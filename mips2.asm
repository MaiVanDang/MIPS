.eqv MONITOR_SCREEN 0x10000000 #Dia chi bat dau cua bo nho man hinh
.eqv RED 0x00FF0000 #Cac gia tri mau thuong su dung
.eqv GREEN 0x0000FF00
.eqv BLUE 0x000000FF
.eqv WHITE 0x00FFFFFF
.eqv YELLOW 0x00FFFF00
.text
	li $k0, MONITOR_SCREEN #Nap dia chi bat dau cua man hinh

#nop
#li $t0, GREEN
#sw $t0, 4($k0)
#nop
#li $t0, BLUE
#sw $t0, 8($k0)
#nop
#li $t0, WHITE
#sw $t0, 12($k0)
#nop
#li $t0, YELLOW
#sw $t0, 16($k0)
#nop
#li $t0, WHITE
#lb $t0, 20($k0)
#nop
	li $s0,0
loop1:
	beq $s0,512,return
	li $t0, RED
	sw $t0, 0($k0)
	addi $k0,$k0,4
	addi $s0,$s0,1
	j	loop1
return:
loop2:
	beq $s0,1024,return
	li $t0, WHITE
	sw $t0, 0($k0)
	addi $k0,$k0,4
	addi $s0,$s0,1
	j	loop2

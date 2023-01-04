2.data 
	array: 0x10010040
.data 0x10010040
	string: .asciiz "fred"
	
.text
	la $t1, array
	lw $t2, 0($t1)
	li $t4, 0	
ehzero:
	lbu $t3, 0($t2)
	beqz $t3, achou
	add $t4, $t4, 1
	add $t2, $t2, 1
	j ehzero
	
achou: sw $t4, 4($t1)
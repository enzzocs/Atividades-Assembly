.data 
array: .word 0x10010040, 8, 9
.data 0x10010040
vetor: 1,2,3,4,5,6,7,8
.text
	la $t1, array
	lw $t2, 0($t1)
	lw $t3, 4($t1)
	lw $t4, 8($t1)
	li $t6, 1

loop:
	lw  $t5, 0($t2)
	beq $t5, $t4, deucerto
	addi $t2, $t2, 4 
	sub $t3, $t3, 1
	bgez $t3, loop
	sw $t6, 16($t1)
	j end
	
deucerto:
	sw $t6, 12($t1)

end:
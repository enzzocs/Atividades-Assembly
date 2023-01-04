.data 
array: 0x10010040, 0x10010060, 4
.data 0x10010040
fonte: 200, -143, 57, -86

.text
la $t1, array
lw $t2, 0($t1)
lw $t3, 4($t1)
lw $t4, 8($t1)

copia:
	lw $t5, 0($t2)
	sw $t5, 0($t3)
	add $t2, $t2, 4
	add $t3, $t3, 4
	sub $t4, $t4, 1
	beqz $t4, acabou
	j copia
	
acabou:
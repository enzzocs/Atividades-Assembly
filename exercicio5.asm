.data

numeros: 22, 23, 0

.text
	la $t1, numeros
	lw $s1, 0($t1)
	lw $s2, 4($t1)
	beq $s1, $s2, compara
break
	
compara: sw $s1, 8($t1)
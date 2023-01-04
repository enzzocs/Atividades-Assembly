.data

numeros: .word 23, 50, 0


.text
	la $t1, numeros
	lw $s1, 0($t1)
	lw $s2, 4($t1)
	add $s1, $s1, $s2
	sw $s1, 8($t1)
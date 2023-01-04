.data

numeros: .word 9, 13, 95

.text
	la $t1, numeros
	lw $s1, 0($t1)
	lw $s2, 4($t1)
	sub $s3, $s1, $s2
	bgez $s3, maior
	sw $s2, 8($t1)
break

maior: sw $s1, 8($t1)
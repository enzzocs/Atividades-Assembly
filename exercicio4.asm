.data

numeros: .word -13, 9, 95

.text
	la $t1, numeros
	lw $s1, 0($t1)
	bgez $s1, maior
	sw $s1, 8($t1)
break

maior: 	sw $s1, 4($t1)
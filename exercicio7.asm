.data

numeros: .word 9, 8, 95

.text
	la $t1, numeros
	lw $s1, 0($t1)
	lw $s2, 4($t1)
	sub $s3, $s1, $s2
	bgez $s3, maior
       sw $s1, 12($t1)
       sw $s2, 20($t1)
break
	
maior: sw $s2, 12($t1)
       sw $s1, 20($t1)
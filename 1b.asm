# v= $a0, qtd= $a1, aux= $t0, k= $t1, i= $t2, j= $t3
.data
v: .word 16, 11, 96, 14, 2, 4, 8, 64, 3, 94
.text
la $a0, v
li $a1, 10
jal bubble
j end

bubble:
	li $t2, 0
	li $t3, 0
	sub $t1, $a1, 1
for1:	
	add $t0, $a0, $zero #permite continuar com o endereço do vetor e ter ele salvo em outro lugar para operações momentaneas
	bge $t2, $a1, acabou
for2:
	bge $t3, $t1, for1_complemento
	lw $t4, 0($t0) #v[j]
	lw $t5, 4($t0) #v[j+1]
	bgt $t5, $t4, for2_complemento
	#add $t0, $a0, $zero
	sw $t5, 0($t0)
	sw $t4, 4($t0)

for2_complemento:
	add $t3, $t3, 1
	add $t0, $t0, 4
	j for2

for1_complemento:
	#la $a0, v
	li $t3, 0
	add $t2, $t2, 1
	sub $t1, $t1, 1
	j for1
	
acabou:
	jr $ra
	
end:
	

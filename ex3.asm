#i= $a0
li $a0, 1
jal fatorial
move $s0, $v0
j end

fatorial:
	add $t1, $zero, $a0
	beq $a0, 1, fim_fatorial
	mul $t0, $a0, 4
	addu $sp, $sp, $t0
salvando_pilha:
	beq $t1, 0, fim_salvar
	sw $t1, 0($sp)
	sub $t1, $t1, 1
	sub $sp, $sp, 4
	j salvando_pilha
fim_salvar:
	add $t3, $zero, $a0
	li $t1, 1
multiplicacao:
	beq $t3, 0, fim_fatorial
	lw $t2, 4($sp)
	mul $t1, $t2, $t1
	add $sp, $sp, 4
	sub $t3, $t3, 1
	j multiplicacao
fim_fatorial:
	add $v0, $t1, $zero
	jr $ra
	
end:

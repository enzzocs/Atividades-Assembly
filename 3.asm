#i= $a0

li $a0, 12
jal fatorial
move $s0, $v0
j end

fatorial:
	li $t0, 1
	beq $a0, 1, fim_fatorial1
operacao:
	beqz $a0, fim_fatorial
	mul $t0, $t0, $a0
	sub $a0, $a0, 1
	j operacao
fim_fatorial:
	add $v0, $t0, $zero
	jr $ra
	
fim_fatorial1:
	li $a0, 1
	add $v0, $a0, $zero
	jr $ra
end:

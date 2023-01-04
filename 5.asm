.data
numeros: .asciiz "Digite os numeros para A, B , C e D: \n"
virgula_espaço: .asciiz ", "
#string:
#numeros: .asciiz "Digite os 4 numeros: \n"

.text
#la $t1, string
li $t0, 102
addu $sp, $sp, 408
loop:
	beqz $t0, gerou
	li $a1, 100 #Here you set $a1 to the max bound.
	li $v0, 42 #generates the random number.
	syscall
	sw $a0, 0($sp)
	sub $sp, $sp, 4
	sub $t0, $t0, 1
	j loop
gerou:
	li $a1, 0
	la $t1, numeros
	li $v0, 4 
	add $a0, $t1, $zero
	syscall
	
	li $a0, 0
	
	li $v0, 5 #pega o numero digitado A
	syscall
	add $a0, $a0, $v0
	
	li $v0, 5 #pega o numero digitado B
	syscall
	add $a1, $a1, $v0
	
	li $v0, 5 #pega o numero digitado C
	syscall
	add $a2, $a2, $v0
	
	li $v0, 5 #pega o numero digitado D
	syscall
	add $a3, $a3, $v0
	
	jal filtro_digital
	j end
filtro_digital:
	li $t6, 100
	add $t5, $a0, $zero
loop2:
	beq $t6, 0, fim
	
	lw $t0, 12($sp) #x(n)
	lw $t1, 8($sp) #x(n-1)
	lw $t2, 4($sp) #x(n-2)
	
	mul $s0, $t5, $t0
	mul $s1, $a1, $t1
	mul $s2, $a2, $t2
	
	add $s0, $s0, $s1
	add $s0, $s0, $s2
	
	div $s0, $s0, $a3
	
	li $v0, 1
	add $a0, $s0, $zero
	syscall 
	
	la $t1, virgula_espaço
	li $v0, 4 
	add $a0, $t1, $zero
	syscall
	
	add $sp, $sp, 4
	sub $t6, $t6, 1
	j loop2
	
fim:
	jr $ra
	
end:

	
	

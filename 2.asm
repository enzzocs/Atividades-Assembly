.data
array: .space 64
menu: .asciiz "\nEscolha uma operação com a string! \n1. Definir valores do array. \n2. Imprimir o array. \n3. Imprimir o array ordenado de forma crescente. \n4. Imprimir o array ordenado de forma decrescente. \n5. Calcular o somatório do array. \n6. Calcular a media aritmética do array. \n7. Calcular a média geométrica modificada do array. \n8. Encerrar o programa.\n"
novo_numero: .asciiz "Digite o novo numero: \n"
adicionar: .asciiz "Deseja adicionar outro numero (1 sim 2 nao): \n"
virgula_espaço: .asciiz ", "
#escolha: .space 5
.text
selecao:
la $t1, menu
li $v0, 4 
add $a0, $t1, $zero
syscall

#la $t2, escolha
li $v0, 5 #armazena a escolha de numero
syscall

la $a3, array

beq $v0, 1, um
beq $v0, 2, dois
beq $v0, 3, tres
beq $v0, 4, quatro
beq $v0, 5, cinco
beq $v0, 6, seis
beq $v0, 8, oito
j selecao

um: 
jal define_array
j selecao

dois:
jal imprime_array
j selecao

tres:
jal imprime_crescente
j selecao

quatro:
jal imprime_decrescente
j selecao

cinco:
jal imprime_somatorio
j selecao

seis:
jal imprime_aritmetica
j selecao

oito:
jal encerrar
j selecao

define_array: #sempre que for iniciado ira sobreescrever a antiga string
	la $t3, array
	li $s0, 0 #contador de numeros no array
adiciona_numero:
	la $t1, novo_numero
	li $v0, 4 
	add $a0, $t1, $zero
	syscall

	li $v0, 5 #pega o numero digitado
	syscall

	sw $v0, 0($t3)
	add $t3, $t3, 4
	add $s0, $s0, 1 #contador de numeros no array
	
	
	la $t1, adicionar #pergunta adicionar mais numeros
	li $v0, 4 
	add $a0, $t1, $zero
	syscall
	
	li $v0, 5 #armazena a escolha de numero
	syscall
	
	beq $v0, 1, adiciona_numero
	jr $ra #fim define_array
	
	
imprime_array:
	add $s1, $s0, $zero
	la $t3, array
imprimir:
	beqz $s1, fim_imprimir
	lw $t4, 0($t3)
	
	li $v0, 1
	add $a0, $t4, $zero
	syscall 
	
	la $t1, virgula_espaço
	li $v0, 4 
	add $a0, $t1, $zero
	syscall
	
	sub $s1, $s1, 1
	add $t3, $t3, 4
	
	j imprimir
fim_imprimir:
	jr $ra #fim imprime_array
	
	
imprime_crescente:
	add $s1, $s0, $zero
	la $t6, array
	li $t2, 0
	li $t3, 0
	sub $t1, $s1, 1
for1:	
	add $t0, $t6, $zero #permite continuar com o endereço do vetor e ter ele salvo em outro lugar para operações momentaneas
	bge $t2, $s1, acabou
for2:
	bge $t3, $t1, for1_complemento
	lw $t4, 0($t0) #v[j]
	lw $t5, 4($t0) #v[j+1]
	bgt $t5, $t4, for2_complemento
	sw $t5, 0($t0)
	sw $t4, 4($t0)

for2_complemento:
	add $t3, $t3, 1
	add $t0, $t0, 4
	j for2

for1_complemento:
	li $t3, 0
	add $t2, $t2, 1
	sub $t1, $t1, 1
	j for1
	
acabou:
	j imprime_array
	jr $ra #fim imprime_crescente
	
	
imprime_decrescente:
	add $s1, $s0, $zero #permite continuar com o numero de elementos e poder utiliza-los na operação a partir de $s1
	la $t6, array
	li $t2, 0
	li $t3, 0
	sub $t1, $s1, 1
for1.1:	
	add $t0, $t6, $zero #permite continuar com o endereço do vetor e ter ele salvo em outro lugar para operações momentaneas
	bge $t2, $s1, acabou.1
for2.1:
	bge $t3, $t1, for1.1_complemento
	lw $t4, 0($t0) #v[j]
	lw $t5, 4($t0) #v[j+1]
	bgt $t4, $t5, for2.1_complemento
	sw $t5, 0($t0)
	sw $t4, 4($t0)

for2.1_complemento:
	add $t3, $t3, 1
	add $t0, $t0, 4
	j for2.1

for1.1_complemento:
	li $t3, 0
	add $t2, $t2, 1
	sub $t1, $t1, 1
	j for1.1
	
acabou.1:
	j imprime_array
	jr $ra #fim imprime_decrescente
	
	
imprime_somatorio:
	add $s1, $s0, $zero #permite continuar com o numero de elementos e poder utiliza-los na operação a partir de $s1
	li $t4, 0
	la $t3, array
teste_zero: 
	beq $s1, 0, fim_somatorio
	lw $t5, 0($t3)
	add $t4, $t4, $t5
	sub $s1, $s1, 1
	add $t3, $t3, 4
	j teste_zero
fim_somatorio:
	li $v0, 1
	add $a0, $t4, $zero
	syscall 
	jr $ra #fim imprime_somatorio
	
	
imprime_aritmetica:
	add $s1, $s0, $zero #permite continuar com o numero de elementos e poder utiliza-los na operação a partir de $s1
	li $t4, 0
	la $t3, array
teste_zero.1: 
	beq $s1, 0, fim_aritmetica
	lw $t5, 0($t3)
	add $t4, $t4, $t5
	sub $s1, $s1, 1
	add $t3, $t3, 4
	j teste_zero.1
fim_aritmetica:
	div $t6, $t4, $s0
	
	li $v0, 1
	add $a0, $t6, $zero
	syscall 
	jr $ra #fim imprime_aritmetica
	
encerrar:
	
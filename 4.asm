#arumentos da função: $a0: endereço frase, $a1: caractere a procurar, $a2: caractere substituição, $a3: tamanho frase
.data 
frase: .asciiz "bote uma frase\n"
procurar: .asciiz "e" #letra para procurar
substitui: .asciiz "i" #letra para substituir

.text
 la $a0, frase
 la $t1, procurar
 lb $a1, 0($t1)
 la $t2, substitui
 lb $a2, 0($t2)
 li $a3, 14
 jal substituir
 j end
 
substituir:
 
 loop:
	lb $t4, 0($a0)
	beq $t4, $a1, troca
condicao:
	sub $a3, $a3, 1
	add $a0, $a0, 1
	beq $a3, 0, fim
	j loop
	
troca: 
	sb $a2, 0($a0)
	j condicao
	
fim:
	la $t0, frase
	li $v0, 4
	add $a0, $zero, $t0
	syscall
	jr $ra
	
end:

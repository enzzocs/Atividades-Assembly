.data 0x10050000 #mudei o endereço do .data para poder usar o diplay no 0x10010000
filename: .asciiz "leia.txt"
.align 2
vetor: .space 1024
y: .space 1024
filtro: .space 1024
teste: .space 16
valorA: " Escolha o parametro A de 1 a 9: \n"
buff:

.text
la $a0, filename	# endereço da string com o nome do arquivo
li $v0, 13		# parametro p chamada de abertura
li $a1, 0		# flags (0=read, 1=write)
li $a2, 0		# mode = desnecessário
syscall			# devolve o descritor (ponteiro) do arquivo em $v0

move $a0, $v0		# move o descritor para $a0
li $v0, 14		# parametro de chamada de leitura de arquivo
la $a1, buff		# endereço para armazenamento dos dados lidos
li $a2, 1024		# tamanho máx de caracteres
syscall			# devolve o número de caracteres lidos

li $t1, 1 #so para funcionar (gambiarra)
la $t3, vetor
add $t6, $t3, $zero
loop: #armazena os numeros do .txt, tranformando de chars para numeros inteiros
	beq $t1, 0, transformou
	la $t0, teste
	li $t2, 0
	li $t5, 1
	li $s1, 0
	teste_virgula:
		lb $t1, 0($a1)
		beq $t1, 44, salva_valor #caso seja uma virgula é necessário salvar o valor encontrado antes dela
		beq $t1, 0, salva_valor #se a leitura foi 0 é porque o fim do arquivo foi alcançado
		sub $t1, $t1, 48
		sw $t1, 0($t0) #cada char é dalvo em uma posição de memoria até a virgula ser encontrada
		add $a1, $a1, 1 #proxima posi~]ao de $a1 (buff)
		add $t0, $t0, 4 #proximo endereço de teste
		add $t2, $t2, 1 #Indicação da magnitude do numero
		j teste_virgula
		
	salva_valor: #loop que da o valor em inteiro para cada char antes da virgula, $t5 é o multiplicador que vai sendo multiplicado por 10
		beq $t2, 0, salva #quando $t2 chega a 0 é porque todas as operações ja foram feitas (ele decresce a cada laço)
		lw $t4, -4($t0)
		mul $s0, $t4, $t5
		mul $t5, $t5, 10
		add $s1, $s0, $s1
		sub $t2, $t2, 1
		sub $t0, $t0, 4
		j salva_valor
		
	salva: #Salva o numero ja tranformado em inteiro no vetor
		sw $s1, 0($t3)
		add $t3, $t3, 4
		add $a1, $a1, 1
		add $s2, $s2, 1 #contagem de valores adicionados
		j loop
		
transformou: #continuação do programa apos todos os valores terem sido armazenados
	add $t3, $t6, $zero #endereço inicial vetor
	lw $s1, 0($t3)
	add $t5, $s2, $zero #salva o numero de valores adicionados em outro registrador para esta poder ser utilizado e manter a informação
	
maiornumero: #laço para varrer o vetor e procurar o maio numero
	add $t3, $t3, 4
	lw $t7, 0($t3)
	sub $t5, $t5, 1
	beq $t5, -1, fim_maiornumero
	bge $s1, $t7, maiornumero #caso o valor armazenado em $t3 seja maior que o valor da nova posição deve-se avançar para o proximo numero
	add $s1, $t7, $zero #coloca o maior numero em $s1
	j maiornumero
	
fim_maiornumero:
	add $t6, $s2, $zero #numero de elementos do vetor
	li $a1, 0 #posição X, este é so ser adicionado 1 para saber a nova posição do novo numero
	la $t3, vetor
	la $s4, y #vetor que salva a posição de y da forma que é util para ser printada (pois a varredura do siplay começa de cima e nao de baixo como em coordenadas cartesianas)
	li $a3, 0x000000FF #Color (Vai ser usado no drawLine tambem)- Azul
	
comparacao:	
	beq $t6, 0, fim_SetPixel
	
	lw $t0, 0($t3) #pega o valor d vetor e depois realiza a regra de 3 utilizando o maior numero para saber sua posição
	mul $a2, $t0, 255
	div $a2, $a2, $s1
	li $t1, 255
	sub $a2, $t1, $a2 #posição Y. É necessário subtrair de 255 para ver quantas linhas deve descer, já que a escrita no display começa por cima e o valor encontrado anteriormente se refere a y=0
	sw $a2, 0($s4)
	jal setPixel
	add $a1, $a1, 4 #manda x para a proxima posição
	add $s4, $s4, 4 #proxima posição de memoria do vetor y
	add $t3, $t3, 4 #proxima posição de memoria do vetor
	sub $t6, $t6, 1 #tira 1 da contagem
	j comparacao
	
setPixel:
	la $t0, 0x10010000 #endereço inicial do display
	add $t0, $a1, $t0 #soma x para saber a coluna
	mul $a2, $a2, 1024 #multiplica y por 1024 para saber quantas linhas deve descer
	add $t0, $t0, $a2 #soma o valor encontrado de y ao endereço
	sw $a3, 0($t0) #salva a cor no endereço encontrado
	jr $ra

fim_SetPixel:
	la $s4, y
	li $t2, 0 #x1
	li $t3, 4 #x2
	add $t8, $s2, $zero #contagem numeros
	sub $t8, $t8, 1
	
	fazendo_drawLine:
	beq $t8, 0, fim_da_linha
	
	lw $t0, 0($s4) #y1
	lw $t1, 4($s4) #y2
	jal drawLine
	add $s4, $s4, 4
	add $t2, $t2, 4
	add $t3, $t3, 4
	sub $t8, $t8, 1
	j fazendo_drawLine
	
	drawLine:
		sub $t5, $t0, $t1 #compara os valores de y para ver se a linha deve subir ou descer
		bltz $t5, desce_linha
		sobe_linha:
		ble $t0, $t1, fim_drawLine #repete o processo ate chegar no ponto da outra coluna, como coloquei como equal a linha nao chega até o ponto fica uma linha abaixo, achei mais bonito
		la $t6, 0x10010000 #endereço incial do display
		add $t6, $t6, $t2 #soma em x
		mul $t7, $t0, 1024
		add $t6, $t7, $t6 #soma em Y
		sw $a3, 0($t6)
		sub $t0, $t0, 1
		j sobe_linha
		j fim_drawLine
		
		desce_linha:
		bge $t0, $t1, fim_drawLine #repete o processo ate chegar no ponto da outra coluna
		la $t6, 0x10010000 #endereço incial do display
		add $t6, $t6, $t3 #soma em x2 para a curva ficar um pouco melhor
		mul $t7, $t1, 1024
		add $t6, $t7, $t6 #soma em Y
		sw $a3, 0($t6)
		sub $t1, $t1, 1
		j desce_linha
		
		fim_drawLine:
		jr $ra
	
fim_da_linha:
	beq $s6, 1, fim_programa #depois do filtro o programa ira voltar para a parte de botar os pontos e a drawline, esta linha garante que ele nao volte parao filtro depois de fazer tudo
	li $s6, 1 #bota $s6 para 1 para que o programa nao passe da proxima vez nessa parte
	add $t6, $s2, $zero #total de numeros do vetor
	la $t0, vetor #carrega endereço do vetor
	la $t1, filtro #carrega endereço do filtro
	li $t2, 0 
	sw $t2, ($t1) #carrega a primeira posição do filtro em zero, para ser utilizado pelo programa, acabei deixando a primeira posição como zero, nao sei se seria melhor botar o primeiro valor como o proximo
	add $t1, $t1, 4 #pula para a proxima posição de filtro
	
	la $t2, valorA #pedido para escrever o numero de 1 a 9
	li $v0, 4
	add $a0, $zero, $t2
	syscall
	
	li $v0, 5 #leitura do numero digitado
	syscall
	add $s5, $v0, $zero
inicio_filtro:
	beq $t6, 0, salvou_buffer #loop com a equação do filtro
	li $t2, 10
	lw $t3, -4($t1) #y(n-1)
	lw $t4, 0($t0) #x(n)
	mul $t4, $t4, $s5 #a.x(n)
	sub $t2, $t2, $s5 #10-a
	mul $t3, $t3, $t2 #(10-a).y(n-1)
	add $t3, $t3, $t4 #a.x(n) + (10-a).y(n-1)
	div $t3, $t3, 10 #[a.x(n) + (10-a).y(n-1)] / 10
	sw $t3, 0($t1) #salva o numero no vetor de filtro
	add $t1, $t1, 4 #adições e subtraçoes para a proxima etapa do loop
	add $t0, $t0, 4
	sub $t6, $t6, 1
	j inicio_filtro
	
	salvou_buffer: #esta parte serve para que o programa possa voltar para o setpixel na parte de comparação, entao foram aproveitados os registradores que sao usados antes disso pelo programa, desta forma é possivel fazer este retorno, e como o $s6 esta em 1 o programa ira finalizar ao inves de ficar em um loop infinito
	la $t3, filtro
	li $a3, 0x0000FF00 #Color verde
	add $t6, $s2, $zero
	li $a1, 0
	la $s4, y
	j comparacao
	
fim_programa:
	
	
	
	

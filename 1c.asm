# src= $a0, dst= $a1, bytes= $a3
.data
src: 1, 4, 93, 45, 3
dst:
.text
la $a0, src 
la $a1, dst
li $a3, 5
jal memcpy
j end

memcpy:
while:	
	beqz  $a3, acabou
	lw $t0, 0($a0)
	sw $t0, 0($a1)
	add $a0, $a0, 4
	add $a1, $a1, 4
	sub $a3, $a3, 1
	j while
acabou:
	jr $ra
end:
	
	
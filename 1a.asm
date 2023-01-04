# num= $a0, res= $t0, bit= $t1
.text
li $a0, 9
jal isqrt
move $t3, $v0
j end

isqrt:
	li $t0, 0
	li $t1, 1
	sll $t1, $t1, 30
while1:	ble $t1, $a0, funcionou #while bit> num
        srl $t1, $t1, 2
        j while1
funcionou: 
	beqz $t1, acabou
	add $t2, $t0, $t1 #$t2= res + bit
	blt $a0, $t2, else
	sub $a0, $a0, $t2 #inicio end
	srl $t0, $t0, 1
	add $t0, $t0, $t1 #fim end
	j fim_end
else: srl $t0, $t0, 1
	j fim_end
fim_end: srl $t1, $t1, 2
	j funcionou
acabou: add $v0, $t0, $zero
        jr $ra

end:

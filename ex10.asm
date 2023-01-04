.data 
vetor: .word 3,4
.text
la $t1, vetor
lw $s1, 0($t1)
lw $s2, 4($t1)
mult $s1, $s2 
mflo $s1
sw $s1, 8($t1)

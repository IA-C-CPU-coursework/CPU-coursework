addiu $t0,$zero,5000
addiu $t1,$zero,10
addiu $sp,$zero,0x400
div $t0,$t1
mfhi $t2
mflo $t3
sw $t2,0x0($sp)
sw $t3,0x4($sp)
jr zero
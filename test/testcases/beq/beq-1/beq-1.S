addiu $t2,$zero,0x1234
addiu $t3,$zero,0x1234
beq $t3,$t2,labela
addiu $v0,$v0,0x00bb
jr $zero
<<<<<<< HEAD
addiu $v0,$v0,0x1234
=======
addiu $v0,$v0,1
>>>>>>> origin
labela:addiu $v0,$v0,0x00aa
jr $zero

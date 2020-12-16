addiu $t2,$zero,0x1234
addiu $t3,$zero,0x1232
bne $t3,$t2,labela
addiu $v0,$v0,0x00bb
jr $zero
addiu $v0,$v0,0
labela:addiu $v0,$v0,0x00aa
jr $zero
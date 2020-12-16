addiu $t2,$zero,0xf234
bgez $t2,labela
addiu $v0,$zero,0x00aa
jr $zero
addiu $v0,$v0,0
labela:addiu $v0,$zero,0x00bb
jr $zero
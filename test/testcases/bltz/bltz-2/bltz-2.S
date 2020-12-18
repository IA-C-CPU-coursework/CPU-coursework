addiu $t0,$zero,0x0000
bltz  $t0,labela
addiu $v0,$v0,0x00aa
jr $zero
labela:addiu $v0,$v0,0x00bb
jr $zero

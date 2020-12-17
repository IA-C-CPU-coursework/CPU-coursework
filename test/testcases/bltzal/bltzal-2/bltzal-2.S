addiu $t2,$zero,0x0000
bltzal $t2,labela
addiu $v0,$v0,0x0044
jr $zero
addiu $v0,$v0,0x00bb
labela:addiu $v0,$v0,0x0066
jr $31
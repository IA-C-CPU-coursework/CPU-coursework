addiu $t2,$zero,0xf234
bgezal $t2,labela
addiu $v0,$v0,0x0055
jr $zero
addiu $v0,$v0,0
labela:addiu $v0,$v0,0x0055
jr $31
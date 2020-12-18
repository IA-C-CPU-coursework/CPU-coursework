addiu $v0,$zero,0xffff
bltz  $v0,labela
jr $zero
labela:addiu $v0,$zero,0x00aa
jr $zero

lui $s0,0xbfc0
addiu $s0,$s0,0x0400
addiu $v0,$zero,0x1234
lh $v0,4($s0)
jr $ra
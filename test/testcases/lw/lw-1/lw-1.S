lui $s0,0xbfc0
addiu $s0,$s0,0x0400
addiu $v0,$zero,0x1234
lw $v0,0($s0)
jr $ra
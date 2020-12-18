.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lbu $v0,0($s0)
jr $ra
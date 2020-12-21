.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0405
lbu $v0,-4($s0)
jr $ra
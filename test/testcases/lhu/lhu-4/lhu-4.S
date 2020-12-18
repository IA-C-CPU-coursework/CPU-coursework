.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
addiu $v0,$zero,0x123e
lhu $v0,-4($s0)
jr $ra
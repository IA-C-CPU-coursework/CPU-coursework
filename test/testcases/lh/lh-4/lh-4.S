.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0408
addiu $v0,$zero,0x123e
lh $v0,-4($s0)
jr $ra
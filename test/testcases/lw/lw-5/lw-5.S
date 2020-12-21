.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0403
addiu $v0,$zero,0x1234
lw $v0,1($s0)
jr $ra
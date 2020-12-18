.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0404
lb $v0,-3($s0)
jr $ra
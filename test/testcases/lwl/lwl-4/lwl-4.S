.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwl $v0,3($s0)
jr $ra
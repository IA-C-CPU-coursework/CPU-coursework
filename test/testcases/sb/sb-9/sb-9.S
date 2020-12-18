.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui $t1,0x1234
addiu $t1,$t1,0xf67b
sb $t1,121($s0)
lb $v0,121($s0)
jr $ra
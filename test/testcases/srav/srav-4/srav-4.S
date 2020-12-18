.set noreorder
lui $t1,0xffff
addiu $t1,$t1,0xffff
lui $s0,0x1234
ori $s0,$s0,0x001f
srav $v0,$t1,$s0
jr $ra
.set noreorder
lui $t1,0xfc12
addiu $t1,$t1,0x7653
lui $s0,0x1234
ori $s0,$s0,0xfc11
srav $v0,$t1,$s0
jr $ra
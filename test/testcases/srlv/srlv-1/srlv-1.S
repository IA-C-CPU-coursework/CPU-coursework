lui $t1,0x1234
addiu $t1,$t1,0x7653
addiu $s0,$zero,0x0004
srlv $v0,$t1,$s0
jr $ra
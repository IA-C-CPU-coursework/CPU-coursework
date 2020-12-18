.set noreorder
lui $t1,0x1234
addiu $t1,$t1,0x7653
lui $s0,0x3456
addiu $s0,$s0,0x6725
sllv $v0,$t1,$s0
jr $ra
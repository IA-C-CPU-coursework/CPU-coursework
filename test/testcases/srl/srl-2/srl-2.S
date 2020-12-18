.set noreorder
lui $t1,0xf234
addiu $t1,$t1,0x7653
srl $v0,$t1,4
jr $ra
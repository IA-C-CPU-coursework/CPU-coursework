.set noreorder
lui $t1,0x1234
addiu $t1,$t1,0x7653
sra $v0,$t1,0
jr $ra
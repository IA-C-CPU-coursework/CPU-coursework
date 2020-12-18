lui $s0,0xbfc0
addiu $s0,$s0,0x04c0
lui $t1,0x1234
addiu $t1,$t1,0x7653
sw $t1,-205($s0)
lw $v0,-205($s0)
jr $ra
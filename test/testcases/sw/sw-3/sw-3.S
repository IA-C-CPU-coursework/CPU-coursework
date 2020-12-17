lui $s0,0xbfc0
addiu $s0,$s0,0x0404
lui $t1,0xf234
addiu $t1,$t1,0x7653
sw $t1,-4($s0)
lw $v0,-4($s0)
jr $ra
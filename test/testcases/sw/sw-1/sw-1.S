.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0x7653
sw $t1,16($s0)
lw $v0,16($s0)
jr $ra
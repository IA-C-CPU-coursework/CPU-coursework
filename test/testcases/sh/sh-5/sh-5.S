.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xc123
sh $t1,125($s0)
lw $v0,125($s0)
jr $ra
lui $s0,0xbfc0
addiu $s0,$s0,0x04c0
lui $t1,0x1234
addiu $t1,$t1,0xf653
sh $t1,-123($s0)
lw $v0,-123($s0)
jr $ra
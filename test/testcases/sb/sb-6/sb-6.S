lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui $t1,0x1234
addiu $t1,$t1,0xf6ab
sb $t1,-3($s0)
lw $v0,-4($s0)
jr $ra
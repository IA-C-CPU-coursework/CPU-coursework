lui $t1,0xffff
ori $t1,$t1,0xffff
addiu $v0,$zero,0x7235
lui $s0,0xffff
ori $s0,$s0,0xffff
sllv $v0,$t1,$s0
jr $ra
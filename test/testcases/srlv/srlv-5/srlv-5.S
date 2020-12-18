.set noreorder
addiu $t1,$zero,0
addiu $v0,$zero,0x1234
addiu $s0,$zero,0
srlv $v0,$t1,$s0
jr $ra
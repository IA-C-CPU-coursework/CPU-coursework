.set noreorder
lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
addiu $t1,$t1,0xffff
sltu $v0,$t0,$t1
jr $ra
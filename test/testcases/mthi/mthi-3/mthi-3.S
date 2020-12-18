addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
mthi $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra
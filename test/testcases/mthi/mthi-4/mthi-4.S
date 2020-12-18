.set noreorder
lui $t0,0xffff
mthi $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra
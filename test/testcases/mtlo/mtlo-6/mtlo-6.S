.set noreorder
addiu $t2,$t2,0x1234
mthi $t2
nop
lui $t0,0x8000
mtlo $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra
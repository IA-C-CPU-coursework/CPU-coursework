.set noreorder
lui $t0,0x8000
mtlo $t0
nop
nop
mflo $t1
addiu $v0,$t1,0x0
jr $ra
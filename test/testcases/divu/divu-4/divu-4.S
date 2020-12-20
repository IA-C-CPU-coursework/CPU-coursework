.set noreorder
addiu $t0,$t0,0x0
addiu $t1,$t1,0x1
divu $t0,$t1
mflo $v0
jr $ra
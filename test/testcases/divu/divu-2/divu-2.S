.set noreorder
addiu $t0,$t0,0x5
addiu $t1,$t1,0x3
divu $t0,$t1
mflo $v0
jr $ra
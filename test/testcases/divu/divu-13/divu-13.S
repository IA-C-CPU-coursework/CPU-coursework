.set noreorder
addiu $t0,$t0,0x7
addiu $t1,$t1,-0x3
divu $t0,$t1
mfhi $v0
jr $ra
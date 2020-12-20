.set noreorder
addiu $t0,$t0,-0x1234
addiu $t1,$t1,0x0
divu $t0,$t1
mfhi $v0
jr $ra
addiu $t0,$zero,6895
addiu $t1,$zero,-45
addiu $v0,$zero,0xffffffff
divu $t0,$t1
mflo $v0
jr zero
addiu $t0,$zero,5000
addiu $t1,$zero,10
addiu $v0,$zero,0x400
multu $t0,$t1
mflo $v0
jr zero
addiu $t0,$zero,5000
addiu $t1,$zero,10
addiu $v0,$zero,0x400
div $t0,$t1
mfhi $v0
jr zero
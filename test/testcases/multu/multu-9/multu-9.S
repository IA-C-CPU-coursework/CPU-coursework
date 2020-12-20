.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
lui $t0,0xedcb
addiu $t0,$t0,0x1234
addiu $t0,$t0,0x5678 # $t0 = 0x12345678
addiu $t1,$t1,0x0
multu $t0,$t1
mfhi $v0
jr $ra
.set noreorder
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678
lui $t1,0xedcb
addiu $t1,$t1,0x54c4
addiu $t1,$t1,0x54c4 # $t0 = 0xedcba988 # -0x12345678
mult $t0,$t1
mflo $v0
jr $ra
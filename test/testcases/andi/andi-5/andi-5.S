.set noreorder
lui $t0,0xffff
addiu $t0,$t0,0x7fff
addiu $t0,0x1
andi $v0,$t0,0xffff
jr $ra
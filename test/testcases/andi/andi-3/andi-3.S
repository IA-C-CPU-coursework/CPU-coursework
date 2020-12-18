.set noreorder
addiu $t0,$zero,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
andi $v0,$t0,0xffff
jr $ra
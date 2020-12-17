lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1 # $t0 = 0x7fffffff
addiu $t1,$t1,-0x1
slt $v0,$t0,$t1
jr $ra
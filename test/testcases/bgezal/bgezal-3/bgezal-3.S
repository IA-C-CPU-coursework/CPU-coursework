lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1       # $t0=0x7fffffff
addiu $v0,$v0,0x1
bgezal $t0,l1
addiu $v0,$v0,0x10
jr $zero
addiu $v0,$v0,0x100
l1:
addiu $v0,$v0,0x1000
jr $ra
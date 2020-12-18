addiu $t0,$t0,0xffff
addiu $t1,$t1,0xffff
addiu $v0,$v0,0x1
bne $t0,$t1,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100
l1:
addiu $v0,$v0,0x1000
jr $ra
.set noreorder
addiu $t0,$t0,0x0
addiu $v0,$v0,0x1
blez $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100
l1:
jr $ra
addiu $v0,$v0,0x1000
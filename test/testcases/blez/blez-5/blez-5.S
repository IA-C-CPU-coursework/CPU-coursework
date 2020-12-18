addiu $t0,$t0,-0xa
addiu $v0,$v0,0x1
addiu $v0,$v0,0x10
blez $t0,l2
l1:
addiu $v0,$v0,0x100
jr $ra
l2:
addiu $v0,$v0,0x1000
blez $t0,l1          # negative index, jump backwards
nop
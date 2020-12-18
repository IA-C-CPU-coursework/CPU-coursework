addiu $v0,$v0,0x1
addiu $v0,$v0,0x10
j l2
l1:
addiu $v0,$v0,0x100
jr $ra
l2:
addiu $v0,$v0,0x1000
j l1
nop
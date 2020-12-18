addiu $v0,$v0,0x1
addiu $v0,$v0,0x10
jal l2
addiu $v0,$v0,0x4
l1:
addiu $v0,$v0,0x100
jr $ra
l2:
addiu $v0,$v0,0x1000
jal l1
nop
jr $zero
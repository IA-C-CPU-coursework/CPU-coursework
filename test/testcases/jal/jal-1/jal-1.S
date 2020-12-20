.set noreorder
addiu $v0,$v0,0x1
jal l1
addiu $v0,$v0,0x10
jr $zero
addiu $v0,$v0,0x100
l1:
jr $ra
addiu $v0,$v0,0x1000
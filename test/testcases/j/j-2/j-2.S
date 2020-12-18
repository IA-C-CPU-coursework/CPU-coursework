.set noreorder
j l2
addiu $v0,$v0,0x1
addiu $v0,$v0,0x10
l1:
jr $ra
addiu $v0,$v0,0x100
l2:
j l1
addiu $v0,$v0,0x1000
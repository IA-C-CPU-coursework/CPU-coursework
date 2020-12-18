.set noreorder
addiu $t0,$t0,0xa
addiu $v0,$v0,0x1
bgez $t0,l2
addiu $v0,$v0,0x10
l1:
jr $ra
addiu $v0,$v0,0x100
l2:
bgez $t0,l1          # negative index, jump backwards
addiu $v0,$v0,0x1000
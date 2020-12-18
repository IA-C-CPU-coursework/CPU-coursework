.set noreorder
addiu $t0,$t0,0xa
addiu $v0,$v0,0x1
bgezal $t0,l2
addiu $v0,$v0,0x10
l1:
jr $ra
addiu $v0,$v0,0x100
l2:
bgezal $t0,l1          # negative immediate, jump backwards
addiu $v0,$v0,0x1000
jr $zero
addiu $v0,$v0,0x4000
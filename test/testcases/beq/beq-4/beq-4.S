.set noreorder
addiu $t0,$t0,0x0
addiu $t1,$t1,0x0
addiu $v0,$v0,0x1
beq $t0,$1,l2
addiu $v0,$v0,0x10
l1:
jr $ra
addiu $v0,$v0,0x100
l2:
beq $t0,$t1,l1          # negative index, jump backwards
addiu $v0,$v0,0x1000
.set noreorder
lui $t1,0xbfc0
addiu $t1,$t1,0x1c
jalr $t1
addiu $v0,$v0,0x1
jr $zero
addiu $v0,$v0,0x100
addiu $v0,$v0,0x1000
target:
jr $ra
addiu $v0,$v0,0x10
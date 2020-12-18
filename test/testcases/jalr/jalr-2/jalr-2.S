.set noreorder
lui $t1,0xbfc0
addiu $t1,$t1,0x20
jalr $t1
addiu $v0,$v0,0x1
addiu $v0,$v0,0x100
addiu $v0,$v0,0x1000
jr $zero
target:
addiu $v0,$v0,0x10
nop
jr $ra
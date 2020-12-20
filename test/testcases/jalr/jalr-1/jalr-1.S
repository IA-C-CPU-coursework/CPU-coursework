.set noreorder
lui $t1,0xbfc0
addiu $t1,$t1,0x1c
addiu $v0,$v0,0x1
jalr $t0,$t1
addiu $v0,$v0,0x100
jr $zero
addiu $v0,$v0,0x1000
target:
jr $t0
addiu $v0,$v0,0x10
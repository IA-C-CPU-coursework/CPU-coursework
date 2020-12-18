.set noreorder
lui $t1,0xbfc0
addiu $t1,$t1,0x14
jr $t1
addiu $v0,$v0,0x1
addiu $v0,$v0,0x10
target:
addiu $v0,$v0,0x100
jr $zero
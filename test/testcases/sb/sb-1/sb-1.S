addiu $t3,$zero,0x1234
sll $t3,$t3,16
addiu $t3,$t3,0x56f8
lui $sp,0xbfc0
addiu $sp,$sp,0x0400
sb $t3,0($sp)
jr $zero

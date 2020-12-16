lui $t3,0x1234
addiu $t3,$t3,0x5678
lui $sp,0xbfc0
addiu $sp,$sp,0x0400
sw $t3,0($sp)
jr $zero

addiu $t3,$zero,0xf234
sll $t3,$t3,16
addiu $t3,$t3,0x5678
lui $sp,0xbfc0
addiu $sp,$sp,0x0400
sw $t3,0($sp)
lb $v0,3($sp)
jr $zero

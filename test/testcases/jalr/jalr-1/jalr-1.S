lui $t1,0xbfc0
addiu $t1,$t1,0x20
jalr $t0,$t1
addiu $v0,$v0,0x1
addiu $v0,$v0,0x100
addiu $v0,$v0,0x1000
jr $zero
addiu $v0,$v0,0x10 # jump target
nop
jr $t0

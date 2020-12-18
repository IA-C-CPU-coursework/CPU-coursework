.set noreorder
lui $t0,0xcccc
addiu $t0,$t0,0x5555
addiu $t0,$t0,0x7777
xori $v0,$t0,0xaaaa
jr $ra
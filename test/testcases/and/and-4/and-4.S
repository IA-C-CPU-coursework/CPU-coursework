.set noreorder
lui $t0,0xaaaa          # t0=0xaaaa0000
addiu $v0,$t0,0x0
addiu $t0,$t0,0x5555    # t0=0xaaaa5555
addiu $v0,$t0,0x0
addiu $t0,$t0,0x5555    # t0=0xaaaaaaaa
addiu $v0,$t0,0x0
addiu $t1,$t0,0x0       # t1=0xaaaaaaaa
addiu $v0,$t0,0x0
and $v0,$t0,$t1
jr $ra
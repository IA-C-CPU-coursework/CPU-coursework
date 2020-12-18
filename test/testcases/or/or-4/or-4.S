.set noreorder
lui $t0,0xaaaa          # t0=0xaaaa0000
addiu $t0,$t0,0x5555    # t0=0xaaaa5555
addiu $t0,$t0,0x5555    # t0=0xaaaaaaaa
addiu $t1,$t0,0x0       # t1=0xaaaaaaaa
or $v0,$t0,$t1
jr $ra
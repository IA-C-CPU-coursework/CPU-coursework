.set noreorder
lui $t0,0xaaaa          # t0=0xaaaa0000
addiu $t0,$t0,0x5555    # t0=0xaaaa5555
addiu $t0,$t0,0x5555    # t0=0xaaaaaaaa
lui $t1,0x5555          # t0=0x55550000
addiu $t1,$t1,0x5555    # t1=0x55555555
or $v0,$t0,$t1
jr $ra
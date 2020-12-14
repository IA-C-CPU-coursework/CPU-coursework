addiu $t0,$t1,0b11110000
addiu $t1,$zero,0b10101010
and $t3,$t1,$t0
addiu $v0,$t3,0
jr zero
lui,$s0,0xa1a2
ori,$s0,$s0,0xa3a4
lui,$s1,0xbfc0
addiu,$s1,$s1,0x0404
addiu,$v0,$s1,0
jr,$zero
lwr,$v0,0($s1)
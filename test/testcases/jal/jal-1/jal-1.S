main:
jal sub
addiu $v0,$v0,0x55
addiu $v0,$v0,-0x1
jr $zero

sub:
addiu $v0,$v0,0x55
jr $ra
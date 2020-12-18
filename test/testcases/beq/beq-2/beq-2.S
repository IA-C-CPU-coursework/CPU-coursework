.set noreorder
lui $t0,0xffff          # 0xffff0000
addiu $t1,$t1,0xffff    # 0xffffffff
addiu $v0,$v0,0x1
beq $t0,$t1,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100
l1:
jr $ra
addiu $v0,$v0,0x1000
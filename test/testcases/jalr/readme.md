# Test bench for `jalr`

#### Instruction format

6'b000011|26'b<immediate>

#### Description

GPR[31] <- PC + 8

PC <- PC + GPRLEN..28(immediate||00)

#### Edge cases


#### Test cases

```assembly
# jalr-1

lui $t1,0xbfc0
addiu $t1,$t1,0x20
jalr $t0,$t1
addiu $v0,$v0,0x1
addiu $v0,$v0,0x100
addiu $v0,$v0,0x1000
jr $zero

target:
addiu $v0,$v0,0x10
nop
jr $t0

# v0 ref
00001111
========
```

```assembly
# jalr-1

lui $t1,0xbfc0
addiu $t1,$t1,0x20
jalr $t1
addiu $v0,$v0,0x1
addiu $v0,$v0,0x100
addiu $v0,$v0,0x1000
jr $zero

target:
addiu $v0,$v0,0x10
nop
jr $ra

# v0 ref
00001111
========
```

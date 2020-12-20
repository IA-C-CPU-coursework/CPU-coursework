# Test bench for `jal`

#### Instruction format

6'b000011|26'b<immediate>

#### Description

GPR[31] <- PC + 8

PC <- PC + GPRLEN..28(immediate||00)

#### Edge cases

The remaining upper bits are the corresponding bits of the branch delay slot, before jumping.

#### Test cases

```assembly
# jal-1

addiu $v0,$v0,0x1
jal l1
addiu $v0,$v0,0x10
jr $zero
addiu $v0,$v0,0x100

l1:
jr $ra
addiu $v0,$v0,0x1000

# v0 ref
00001111
========
```

```assembly
# jal-2
# negative immediate

addiu $v0,$v0,0x1
jal l2
addiu $v0,$v0,0x10

l1:
jr $ra
addiu $v0,$v0,0x100

l2:
jal l1
addiu $v0,$v0,0x1000
jr $zero
addiu $v0,$v0,0x1000

# v0 ref
00002111
========
```

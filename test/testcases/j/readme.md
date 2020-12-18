# Test bench for `j`

#### Instruction format

6'b000010|26'b<immediate>

#### Description

PC <- PC + GPRLEN..28(immediate||00)

#### Edge cases

The remaining upper bits are the corresponding bits of the branch delay slot, before jumping.

#### Test cases

```assembly
# j-1

addiu $v0,$v0,0x1
j l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100

l1:
addiu $v0,$v0,0x1000
jr $ra

# v0 ref
00001001
========
```

```assembly
# j-4
# negative immediate

addiu $v0,$v0,0x1
addiu $v0,$v0,0x10
j l2

l1:
addiu $v0,$v0,0x100
jr $ra

l2:
addiu $v0,$v0,0x1000
j l1
nop

# v0 ref
00001111
========
```

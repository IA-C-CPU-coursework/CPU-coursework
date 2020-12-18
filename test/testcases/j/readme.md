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
00001011
========
```

```assembly
# j-4
# negative immediate

j l2
addiu $v0,$v0,0x1
addiu $v0,$v0,0x10

l1:
jr $ra
addiu $v0,$v0,0x100

l2:
j l1
addiu $v0,$v0,0x1000

# v0 ref
00001101
========
```

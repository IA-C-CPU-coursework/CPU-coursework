# Test bench for `bgez`

#### Instruction format

6'b000001|5'b<rs>|5'b00001|16'b<immediate>

#### Description

tgt_offset <- sign_extended(immediate||00)
condition <- (GPR[rs] >= 0)

if condition then
    PC <- PC + tgt_offset
endif

#### Edge cases

immediate is signed, can jump backwards
condition is greater than or equal to zero

#### Test cases

```assembly
# bgez-1
# less than zero

addiu $t0,$t0,-0x1

addiu $v0,$v0,0x1
bgez $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100

l1:
jr $ra
addiu $v0,$v0,0x1000

# v0 ref
00001111
========
```

```assembly
# bgez-2
# greater than zero

addiu $t0,$t0,0x1

addiu $v0,$v0,0x1
bgez $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100

l1:
jr $ra
addiu $v0,$v0,0x1000

# v0 ref
00001011
========
```

```assembly
# bgez-3
# greater than zero

lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1       # $t0=0x7fffffff

addiu $v0,$v0,0x1
bgez $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100

l1:
jr $ra
addiu $v0,$v0,0x1000

# v0 ref
00001011
========
```

```assembly
# bgez-4
# zero

addiu $t0,$t0,0x0

addiu $v0,$v0,0x1
bgez $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100

l1:
jr $ra
addiu $v0,$v0,0x1000

# v0 ref
00001011
========
```

```assembly
# bgez-5
# negative index

addiu $t0,$t0,0xa

addiu $v0,$v0,0x1
bgez $t0,l2
addiu $v0,$v0,0x10

l1:
jr $ra
addiu $v0,$v0,0x100

l2:
bgez $t0,l1          # negative index, jump backwards
addiu $v0,$v0,0x1000

# v0 ref
00001111
========
```

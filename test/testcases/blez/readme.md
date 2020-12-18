# Test bench for `blez`

#### Instruction format

6'b000110|5'b<rs>|5'b00000|16'b<immediate>

#### Description

tgt_offset <- sign_extended(immediate||00)
condition <- (GPR[rs] <= 0)

if condition then
    PC <- PC + tgt_offset
endif

#### Edge cases

immediate is signed, can jump backwards
condition is less than or equal to zero

#### Test cases

```assembly
# blez-1
# less than zero

addiu $t0,$t0,-0x1
addiu $v0,$v0,0x1
blez $t0,l1
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
# blez-2
# greater than zero

addiu $t0,$t0,0x1
addiu $v0,$v0,0x1
blez $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100

l1:
addiu $v0,$v0,0x1000
jr $ra

# v0 ref
00001111
========
```

```assembly
# blez-3
# greater than zero

lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1       # $t0=0x7fffffff

addiu $v0,$v0,0x1
blez $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100

l1:
addiu $v0,$v0,0x1000
jr $ra

# v0 ref
00001111
========
```

```assembly
# blez-4
# zero

addiu $t0,$t0,0x0
addiu $v0,$v0,0x1
blez $t0,l1
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
# blez-5
# negative index

addiu $t0,$t0,-0xa
addiu $v0,$v0,0x1

addiu $v0,$v0,0x10
blez $t0,l2

l1:
addiu $v0,$v0,0x100
jr $ra

l2:
addiu $v0,$v0,0x1000
blez $t0,l1          # negative index, jump backwards
nop

# v0 ref
00001111
========
```

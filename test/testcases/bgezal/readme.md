# Test bench for `bgezal`

#### Instruction format

6'b000001|5'b<rs>|5'b10001|16'b<immediate>

#### Description

tgt_offset <- sign_extended(immediate||00)
condition <- (GPR[rs] >= 0)
GPR[31] <- PC + 8

if condition then
    PC <- PC + tgt_offset
endif

#### Edge cases

immediate is signed, can jump backwards
condition is greater than or equal to zero

#### Test cases

```assembly
# bgezal-1
# less than zero

addiu $t0,$t0,-0x1
addiu $v0,$v0,0x1
bgezal $t0,l1
addiu $v0,$v0,0x10
addiu $v0,$v0,0x100
jr $zero

l1:
addiu $v0,$v0,0x1000
jr $ra

# v0 ref
00000111
========
```

```assembly
# bgezal-2
# greater than zero

addiu $t0,$t0,0x1
addiu $v0,$v0,0x1
bgezal $t0,l1
addiu $v0,$v0,0x10
jr $zero
addiu $v0,$v0,0x100

l1:
addiu $v0,$v0,0x1000
jr $ra

# v0 ref
00001011
========
```

```assembly
# bgezal-3
# greater than zero

lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1       # $t0=0x7fffffff

addiu $v0,$v0,0x1
bgezal $t0,l1
addiu $v0,$v0,0x10
jr $zero
addiu $v0,$v0,0x100

l1:
addiu $v0,$v0,0x1000
jr $ra

# v0 ref
00001011
========
```

```assembly
# bgezal-4
# zero

addiu $t0,$t0,0x0
addiu $v0,$v0,0x1
bgezal $t0,l1
addiu $v0,$v0,0x10
jr $zero
addiu $v0,$v0,0x100

l1:
addiu $v0,$v0,0x1000
jr $ra

# v0 ref
00001011
========
```

```assembly
# bgezal-5
# negative immediate

addiu $t0,$t0,0xa
addiu $v0,$v0,0x1

addiu $v0,$v0,0x10
bgezal $t0,l2

l1:
addiu $v0,$v0,0x100
jr $ra

l2:
addiu $v0,$v0,0x1000
bgezal $t0,l1          # negative index, jump backwards
nop
jr $zero

# v0 ref
00001111
========
```

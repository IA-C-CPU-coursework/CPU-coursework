# Test bench for `bne`

#### Instruction format

6'b000101|5'b<rs>|5'b<rt>|16'b<immediate>

#### Description

tgt_offset <- sign_extended(immediate||00)
condition <- (GPR[rs] != GPR[rt])

if condition then
    PC <- PC + tgt_offset
endif

#### Edge cases

immediate is signed, can jump backwards

#### Test cases

```assembly
# bne-1
# equal

addiu $t0,$t0,0xffff
addiu $t1,$t1,0xffff
addiu $v0,$v0,0x1
bne $t0,$t1,l1
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
# bne-2
# not equal

lui $t0,0xffff          # 0xffff0000
addiu $t1,$t1,0xffff    # 0xffffffff
addiu $v0,$v0,0x1
bne $t0,$t1,l1
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
# bne-3
# equal

addiu $t0,$t0,0x0
addiu $t1,$t1,0x0
addiu $v0,$v0,0x1
bne $t0,$t1,l1
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
# bne-4
# negative immediate

addiu $t0,$t0,0x1
addiu $t1,$t1,0x0

addiu $v0,$v0,0x1
bne $t0,$1,l2
addiu $v0,$v0,0x10

l1:
jr $ra
addiu $v0,$v0,0x100

l2:
bne $t0,$t1,l1          # negative index, jump backwards
addiu $v0,$v0,0x1000

# v0 ref
00001111
========
```

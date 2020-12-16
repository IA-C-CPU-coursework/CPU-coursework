# Test bench for `andi`

#### Instruction format

6'b001100|5'b<rs>|5'b<rt>|16'b<immediate>

#### Description

GPR[rt] <= GPR[rs] and zero_extended(immediate)

#### Edge cases


#### Test cases

```assembly
# andi-1
# 0=0&0
addiu $t0,$zero,0x0
andi $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# andi-2
# 0=0&0xffff
addiu $t0,$zero,0x0
andi $v0,$t0,0xffff
jr $ra

# v0 ref
00000000
========
```

```assembly
# andi-3
# 0xffff = 0xffff & 0xffff
addiu $t0,$zero,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
andi $v0,$t0,0xffff
jr $ra

# v0 ref
0000ffff
========
```

```assembly
# andi-4
# 0=0xffff0000 & 0xffff
lui $t0,0xffff
andi $v0,$t0,0xffff
jr $ra

# v0 ref
00000000
========
```

```assembly
# andi-5
# 0x8000 = 0xffff8000 & 0xffff
lui $t0,0xffff
addiu $t0,$t0,0x7fff
addiu $t0,0x1
andi $v0,$t0,0xffff
jr $ra

# v0 ref
00008000
========
```

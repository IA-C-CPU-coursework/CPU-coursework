# Test bench for `ori`

#### Instruction format

6'b001101|5'b<rs>|5'b<rt>|16'b<immediate>

#### Description

GPR[rt] <= GPR[rs] or zero_extended(immediate)

#### Edge cases


#### Test cases

```assembly
# ori-1
# 0 = 0 | 0
addiu $t0,$zero,0x0
ori $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# ori-2
# 0xffff = 0 | 0xffff
addiu $t0,$zero,0x0
ori $v0,$t0,0xffff
jr $ra

# v0 ref
0000ffff
========
```

```assembly
# ori-3
# 0xffff = 0xffff | 0xffff
addiu $t0,$zero,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
ori $v0,$t0,0xffff
jr $ra

# v0 ref
0000ffff
========
```

```assembly
# ori-4
# 0xffffffff = 0xffff0000 | 0xffff
lui $t0,0xffff
ori $v0,$t0,0xffff
jr $ra

# v0 ref
ffffffff
========
```

```assembly
# ori-5
# 0xffffffff = 0xffff8000 | 0xffff
lui $t0,0xffff
addiu $t0,$t0,0x7fff
addiu $t0,0x1
ori $v0,$t0,0xffff
jr $ra

# v0 ref
ffffffff
========
```

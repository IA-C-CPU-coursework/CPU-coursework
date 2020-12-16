# Test bench for `addiu`

#### Instruction format

6'b001001|5'b<rs>|5'b<rt>|16'b<immediate>

#### Description

GPR[rt] <= GPR[rs] + sign_extended(immediate)

#### Edge cases

immediate: 0xFFFF, 0x0000

rs: 0x1F, 0x00

rt: 0x1F, 0x00

#### Test cases

```assembly
# addiu-1
# 0=0+0
addiu $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========

# data init
01010101
========

# data ref
01010101
========
```

```assembly
# addiu-2
# 1=0+1
addiu $t0,$t0,0x1
addiu $v0,$t0,0x0
jr $ra

# v0 ref
00000001
========

# data init
01010100
00101010
========

# data ref
01010100
00101010
========
```

```assembly
# addiu-3
# sign extension based on imm[15]
addiu $t0,$t0,0x8000
addiu $v0,$t0,0x0
jr $ra

# v0 ref
ffff8000
========
```

```assembly
# addiu-4
# 0xffffffff=0xffff8000+0x7fff
addiu $t0,$t0,0x8000
addiu $v0,$t0,0x7fff
jr $ra

# v0 ref
ffffffff
========
```

```assembly
# addiu-5
# sign extension based on imm[15]
addiu $t0,$t0,0xffff
addiu $v0,$t0,0x0
jr $ra

# v0 ref
ffffffff
========
```

```assembly
# addiu-6
# 0=-1+1
addiu $t0,$t0,0xffff
addiu $v0,$t0,0x1
jr $ra

# v0 ref
00000000
========
```


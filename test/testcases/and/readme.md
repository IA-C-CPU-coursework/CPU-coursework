# Test bench for `and`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|5'b<rd>|5'b00000|5b'100100

#### format
AND rd,rs,rt

#### Description

GPR[rd] <= GPR[rs] and GPR[rt]

#### Edge cases


#### Test cases

```assembly
# and 1
# 0=0&0
and $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# and 2
# 0=0&1
addiu $t0,$zero,0x0
addiu $t1,$zero,0x1
and $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# and 3
# 0=1&1
addiu $t0,$zero,0x1
addiu $t1,$zero,0x1
and $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# and 4
# 0 = 1010101010101010 & 1010101010101010
lui $t0,0xaaaa          # t0=0xaaaa0000
addiu $v0,$t0,0x0
addiu $t0,$t0,0x5555    # t0=0xaaaa5555
addiu $v0,$t0,0x0
addiu $t0,$t0,0x5555    # t0=0xaaaaaaaa
addiu $v0,$t0,0x0
addiu $t1,$t0,0x0       # t1=0xaaaaaaaa
addiu $v0,$t0,0x0
and $v0,$t0,$t1
jr $ra

# v0 ref
aaaaaaaa
========
```

```assembly
# and 5
# 0 = 0101010101010101 & 1010101010101010
lui $t0,0xaaaa          # t0=0xaaaa0000
addiu $v0,$t0,0x0
addiu $t0,$t0,0x5555    # t0=0xaaaa5555
addiu $v0,$t0,0x0
addiu $t0,$t0,0x5555    # t0=0xaaaaaaaa
addiu $v0,$t0,0x0

lui $t1,0x5555          # t0=0x55550000
addiu $v0,$t1,0x0
addiu $t1,$t1,0x5555    # t1=0x55555555
addiu $v0,$t1,0x0
and $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

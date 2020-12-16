# Test bench for `or`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|5'b<rd>|5'b00000|5b'100101

#### Description

GPR[rd] <= GPR[rs] or GPR[rt]

#### Edge cases

#### Test cases

```assembly
# or 1
# 0=0|0
or $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# or 2
# 0=0|1
addiu $t0,$zero,0x0
addiu $t1,$zero,0x1
or $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# or 3
# 0x00010001 = 0x0001 | 0x1
lui $t0,0x1
addiu $t1,$zero,0x1
or $v0,$t0,$t1
jr $ra

# v0 ref
00010001
========
```

```assembly
# or 4
# 0b1010101010101010 = 0b1010101010101010 | 0b1010101010101010
lui $t0,0xaaaa          # t0=0xaaaa0000
addiu $t0,$t0,0x5555    # t0=0xaaaa5555
addiu $t0,$t0,0x5555    # t0=0xaaaaaaaa
addiu $t1,$t0,0x0       # t1=0xaaaaaaaa
or $v0,$t0,$t1
jr $ra

# v0 ref
aaaaaaaa
========
```

```assembly
# or 5
# 0xffffffff = 0b0101010101010101 | 0b1010101010101010
lui $t0,0xaaaa          # t0=0xaaaa0000
addiu $t0,$t0,0x5555    # t0=0xaaaa5555
addiu $t0,$t0,0x5555    # t0=0xaaaaaaaa

lui $t1,0x5555          # t0=0x55550000
addiu $t1,$t1,0x5555    # t1=0x55555555
or $v0,$t0,$t1
jr $ra

# v0 ref
ffffffff
========
```

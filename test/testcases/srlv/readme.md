# Test bench for `srlv`

#### Instruction format



#### Description

shift right based on MSB a value in register 

#### Edge cases



#### Test cases

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
addiu $s0,$zero,0x0004
srlv $v0,$t1,$s0
jr $ra

# v0 ref
01234765
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $t1,0xf234
addiu $t1,$t1,0x7653
addiu $s0,$zero,0x0008
srlv $v0,$t1,$s0
jr $ra

# v0 ref
00f23476
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $t1,0xfc12
addiu $t1,$t1,0x7653
lui $s0,0x1234
ori $s0,$s0,0xfc11
srlv $v0,$t1,$s0
jr $ra

# v0 ref
00007e09
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $t1,0xffff
addiu $t1,$t1,0xffff
lui $s0,0x1234
ori $s0,$s0,0x001f
srlv $v0,$t1,$s0
jr $ra

# v0 ref
00000001
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
addiu $t1,$zero,0
addiu $v0,$zero,0x1234
addiu $s0,$zero,0
srlv $v0,$t1,$s0
jr $ra

# v0 ref
00000000
========

# data init
10101010
========

# data ref
10101010
========
```


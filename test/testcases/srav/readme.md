# Test bench for `srav`

#### Instruction format



#### Description

shift right based on MSB a value in register 

#### Edge cases



#### Test cases

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
addiu $s0,$zero,0x0004
srav $v0,$t1,$s0
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
srav $v0,$t1,$s0
jr $ra

# v0 ref
fff23476
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
srav $v0,$t1,$s0
jr $ra

# v0 ref
fffffe09
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
srav $v0,$t1,$s0
jr $ra

# v0 ref
ffffffff
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
srav $v0,$t1,$s0
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


# Test bench for `sllv`

#### Instruction format



#### Description

shift a value in register 

#### Edge cases



#### Test cases

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
addiu $s0,$zero,0x0004
sllv $v0,$t1,$s0
jr $ra

# v0 ref
23476530
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
lui $s0,0x3456
addiu $s0,$s0,0x6767
sllv $v0,$t1,$s0
jr $ra

# v0 ref
1a3b2980
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
lui $s0,0x3456
addiu $s0,$s0,0x6725
sllv $v0,$t1,$s0
jr $ra

# v0 ref
468eca60
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
ori $t1,$t1,0xffff
addiu $v0,$zero,0x7235
lui $s0,0xffff
ori $s0,$s0,0xffff
sllv $v0,$t1,$s0
jr $ra

# v0 ref
80000000
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
addiu $s0,$zero,0x000f
sllv $v0,$t1,$s0
jr $ra

# v0 ref
3b298000
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
addiu $s0,$zero,0
sllv $v0,$t1,$s0
jr $ra

# v0 ref
12347653
========

# data init
10101010
========

# data ref
10101010
========
```
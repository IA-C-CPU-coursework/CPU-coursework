# Test bench for `srl`

#### Instruction format



#### Description

logical right shift a value in register 

#### Edge cases



#### Test cases

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
srl $v0,$t1,4
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
srl $v0,$t1,4
jr $ra

# v0 ref
0f234765
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
srl $v0,$t1,31
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
lui $t1,0xf1ff
ori $t1,$t1,0xffff
srl $v0,$t1,0
jr $ra

# v0 ref
f1ffffff
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
sra $v0,$t1,31
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

```assembly
lui $t1,0x1234
addiu $t1,$t1,0x7653
srl $v0,$t1,0
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
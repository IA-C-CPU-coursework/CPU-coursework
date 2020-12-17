# Test bench for `lwr`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwr $v0,0($s0)
jr $ra

# v0 ref
b172b3b4
========

# data init
b172b3b4
12345678
========

# data ref
b172b3b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwr $v0,1($s0)
jr $ra

# v0 ref
43b172b3
========

# data init
b172b3b4
12345678
========

# data ref
b172b3b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwr $v0,2($s0)
jr $ra

# v0 ref
4352b1b2
========

# data init
b1b2b3b4
12345678
========

# data ref
b1b2b3b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwr $v0,3($s0)
jr $ra

# v0 ref
435212b1
========

# data init
b1b2b3b4
12345678
========

# data ref
b1b2b3b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0404
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwr $v0,-1($s0)
jr $ra

# v0 ref
435212b1
========

# data init
b172b3b4
12345678
========

# data ref
b172b3b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0404
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwr $v0,-2($s0)
jr $ra

# v0 ref
4352b1b2
========

# data init
b1b2b3b4
12345678
========

# data ref
b1b2b3b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0404
lui $v0,0x4352
addiu $v0,$v0,0x1234
lwr $v0,-3($s0)
jr $ra

# v0 ref
43b1b2b3
========

# data init
b1b2b3b4
12345678
========

# data ref
b1b2b3b4
12345678
========
```
# Test bench for `lbu`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lbu $v0,0($s0)
jr $ra

# v0 ref
000000b4
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
lbu $v0,1($s0)
jr $ra

# v0 ref
000000b3
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
lbu $v0,1($s0)
jr $ra

# v0 ref
00000073
========

# data init
b1b273b4
12345678
========

# data ref
b1b273b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lbu $v0,2($s0)
jr $ra

# v0 ref
000000b2
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
lbu $v0,-1($s0)
jr $ra

# v0 ref
000000b1
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
lbu $v0,-2($s0)
jr $ra

# v0 ref
00000072
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
lbu $v0,-3($s0)
jr $ra

# v0 ref
000000b3
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



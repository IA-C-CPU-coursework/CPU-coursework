# Test bench for `lb`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lb $v0,0($s0)
jr $ra

# v0 ref
ffffffb4
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
lb $v0,1($s0)
jr $ra

# v0 ref
ffffffb3
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
lb $v0,1($s0)
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
lb $v0,2($s0)
jr $ra

# v0 ref
ffffffb2
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
lb $v0,2($s0)
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
lb $v0,-1($s0)
jr $ra

# v0 ref
ffffffb1
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
lb $v0,-2($s0)
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
lb $v0,-3($s0)
jr $ra

# v0 ref
ffffffb3
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



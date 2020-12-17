# Test bench for `lhu`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lhu $v0,0($s0)
jr $ra

# v0 ref
0000b3b4
========

# data init
b172b3b4
12345678
00000000
========

# data ref
b172b3b4
12345678
00000000
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lhu $v0,4($s0)
jr $ra

# v0 ref
00008678
========

# data init
b172b3b4
12348678
00000000
========

# data ref
b172b3b4
12348678
00000000
========
```


```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui,$v0,0x8123
addiu $v0,$zero,0x1234
lhu $v0,4($s0)
jr $ra

# v0 ref
00005678
========

# data init
b172b3b4
12345678
00000000
========

# data ref
b172b3b4
12345678
00000000
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui,$v0,0xc123
addiu $v0,$zero,0x123e
lhu $v0,-4($s0)
jr $ra

# v0 ref
00009876
========

# data init
b172b3b4
12345678
e1349876
12457790
00000000
========

# data ref
b172b3b4
12345678
e1349876
12457790
00000000
========
```


```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0408
lui,$v0,0xc423
addiu $v0,$zero,0x123e
lhu $v0,-4($s0)
jr $ra

# v0 ref
00005678
========

# data init
b172b3b4
12345678
e1349876
12457790
00000000
========

# data ref
b172b3b4
12345678
e1349876
12457790
00000000
========
```
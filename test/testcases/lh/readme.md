# Test bench for `lh`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lh $v0,0($s0)
jr $ra

# v0 ref
ffffb3b4
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
lui,$v0,0x8123
addiu $v0,$zero,0x1234
lh $v0,4($s0)
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
lh $v0,-4($s0)
jr $ra

# v0 ref
ffff9876
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
lh $v0,-4($s0)
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
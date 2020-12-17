# Test bench for `sb`

#### Instruction format



#### Description

store the leaset significant 8 bits in the register to the specific byte in a word address

#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xf653
sb $t1,0($s0)
lw $v0,0($s0)
jr $ra

# v0 ref
b172b353
========

# data init
b172b3b4
12345678
00000000
========

# data ref
b172b353
12345678
00000000
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xf653
sb $t1,5($s0)
lw $v0,4($s0)
jr $ra

# v0 ref
12345378
========

# data init
b172b3b4
12345678
00000000
========

# data ref
b172b3b4
12345378
00000000
========
```



```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xf653
sb $t1,6($s0)
lw $v0,4($s0)
jr $ra

# v0 ref
12535678
========

# data init
b172b3b4
12345678
00000000
========

# data ref
b172b3b4
12535678
00000000
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xf6ab
sb $t1,7($s0)
lw $v0,4($s0)
jr $ra

# v0 ref
ab345678
========

# data init
b172b3b4
12345678
00000000
========

# data ref
b172b3b4
ab345678
00000000
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui $t1,0x1234
addiu $t1,$t1,0xf6ab
sb $t1,-8($s0)
lw $v0,-8($s0)
jr $ra

# v0 ref
123456ab
========

# data init
b172b3b4
12345678
e1349876
12457790
========

# data ref
b172b3b4
123456ab
e1349876
12457790
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui $t1,0x1234
addiu $t1,$t1,0xf6ab
sb $t1,-3($s0)
lw $v0,-4($s0)
jr $ra

# v0 ref
e134ab76
========

# data init
b172b3b4
12345678
e1349876
12457790
========

# data ref
b172b3b4
12345678
e134ab76
12457790
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui $t1,0x1234
addiu $t1,$t1,0xf6ab
sb $t1,-6($s0)
lw $v0,-8($s0)
jr $ra

# v0 ref
12ab5678
========

# data init
b172b3b4
12345678
e1349876
12457790
========

# data ref
b172b3b4
12ab5678
e1349876
12457790
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui $t1,0x1234
addiu $t1,$t1,0xf6ab
sb $t1,-123($s0)
lb $v0,-123($s0)
jr $ra

# v0 ref
ffffffab
========

# data init

========

# data ref

========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x040c
lui $t1,0x1234
addiu $t1,$t1,0xf67b
sb $t1,121($s0)
lb $v0,121($s0)
jr $ra

# v0 ref
0000007b
========

# data init

========

# data ref

========
```
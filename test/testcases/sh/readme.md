# Test bench for `sh`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xf653
sh $t1,16($s0)
lw $v0,16($s0)
jr $ra

# v0 ref
0000f653
========

# data init
b172b3b4
12345678
00000000
00000000
00000000
========

# data ref
b172b3b4
12345678
00000000
00000000
0000f653
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xf653
sh $t1,8($s0)
lw $v0,8($s0)
jr $ra

# v0 ref
1234f653
========

# data init
12121212
b172b3b4
12345678
========

# data ref
12121212
b172b3b4
1234f653
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0408
lui $t1,0x1234
addiu $t1,$t1,0xf653
sh $t1,-8($s0)
lw $v0,-8($s0)
jr $ra

# v0 ref
c1c2f653
========

# data init
c1c2c3c4
00000000
b172b3b4
12345678
========

# data ref
c1c2f653
00000000
b172b3b4
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x04c0
lui $t1,0x1234
addiu $t1,$t1,0xf653
sh $t1,-123($s0)
lw $v0,-123($s0)
jr $ra

# v0 ref
0000f653
========

# data init
10101010
========

# data ref
10101010
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0xc123
sh $t1,125($s0)
lw $v0,125($s0)
jr $ra

# v0 ref
0000c123
========

# data init
10101010
========

# data ref
10101010
========
```
# Test bench for `sw`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0x7653
sw $t1,16($s0)
lw $v0,16($s0)
jr $ra

# v0 ref
12347653
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
12347653
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0xf234
addiu $t1,$t1,0x7653
sw $t1,4($s0)
lw $v0,4($s0)
jr $ra

# v0 ref
f2347653
========

# data init
b172b3b4
12345678
========

# data ref
b172b3b4
f2347653
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0404
lui $t1,0xf234
addiu $t1,$t1,0x7653
sw $t1,-4($s0)
lw $v0,-4($s0)
jr $ra

# v0 ref
f2347653
========

# data init
b172b3b4
12345678
========

# data ref
f2347653
12345678
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0x7653
sw $t1,0($s0)
lw $v0,0($s0)
jr $ra

# v0 ref
12347653
========

# data init
b172b3b4
12345678
========

# data ref
12347653
12345678
========
```


```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
lui $t1,0x1234
addiu $t1,$t1,0x7653
sw $t1,201($s0)
lw $v0,201($s0)
jr $ra

# v0 ref
12347653
========

# data init
12121212
========

# data ref
12121212
========
```

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x04c0
lui $t1,0x1234
addiu $t1,$t1,0x7653
sw $t1,-205($s0)
lw $v0,-205($s0)
jr $ra

# v0 ref
12347653
========

# data init
12121212
========

# data ref
12121212
========
```


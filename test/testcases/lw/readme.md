# Test bench for `lw`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
lui $s0,0xbfc0
addiu $s0,$s0,0x0400
addiu $v0,$zero,0x1234
lw $v0,0($s0)
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
addiu $v0,$zero,0x1234
lw $v0,4($s0)
jr $ra

# v0 ref
12345678
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
addiu $v0,$zero,0x1234
lw $v0,-4($s0)
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
addiu $s0,$s0,0x0404
addiu $v0,$zero,0x1234
lw $v0,8($s0)
jr $ra

# v0 ref
b172b3b4
========

# data init
b172b3b4
12345678
c1c2c3c4
98765432
========

# data ref
b172b3b4
12345678
c1c2c3c4
98765432
========
```




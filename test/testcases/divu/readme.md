# Test bench for `divu`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|10'b0000000000|6b'011011

#### Description

LO <= GPR[rs] divu GPR[rt]
HI <= GPR[rs] mod GPR[rt]

#### Edge cases

positive / positive
positive / negative
positive / zero

zero / positive
zero / negative

#### Test cases

```assembly
# divu-1
# 5/3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

addiu $t0,$t0,0x5
addiu $t1,$t1,0x3
divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
00000001
00000002
========
```

```assembly
# divu-2
# 0/1
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,0x1

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
00000000
00000000
========
```

```assembly
# divu-3
# -1/1
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x1
addiu $t1,$t1,0x1

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
ffffffff
00000000
========
```

```assembly
# divu-4
# -0x1234/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x1234
addiu $t1,$t1,0x0

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
xxxxxxxx
xxxxxxxx
========
```

```assembly
# divu-5
# 1234/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x1234
addiu $t1,$t1,0x0

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
xxxxxxxx
xxxxxxxx
========
```

```assembly
# divu-6
# -7/3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x7
addiu $t1,$t1,0x3

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
55555553
00000000
========
```

```assembly
# divu-7
# 7/-3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x7
addiu $t1,$t1,-0x3

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
00000000
00000007
========
```

```assembly
# divu-8
# -7/-3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x7
addiu $t1,$t1,-0x3

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
00000000
fffffff9
========
```

```assembly
# divu-9
# 0/-12
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,-0xc

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
00000000
00000000
========
```

```assembly
# divu-10
# 0/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,0x0

divu $t0,$t1
mflo $s1
sw $s1,0x0($s0)
mfhi $s2
sw $s2,0x4($s0)
jr $ra

# v0 ref
bfc00400
========

# data ref
xxxxxxxx
xxxxxxxx
========
```

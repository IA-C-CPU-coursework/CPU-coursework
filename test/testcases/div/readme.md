# Test bench for `div`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|10'b0000000000|6b'011010

#### Description

LO <= GPR[rs] div GPR[rt]
HI <= GPR[rs] mod GPR[rt]

#### Edge cases

positive / positive
positive / negative
positive / zero

nagative / positive
negative / negative
negative / zero

zero / positive
zero / negative

#### Test cases

```assembly
# div-1
# 5/3

addiu $t0,$t0,0x5
addiu $t1,$t1,0x3

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000002
========
```

```assembly
# div-1
# 5/3

addiu $t0,$t0,0x5
addiu $t1,$t1,0x3

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
00000001
========
```

```assembly
# div-2
# 0/1
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,0x1

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# div-2
# 0/1
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,0x1

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# div-3
# -1/1
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x1
addiu $t1,$t1,0x1

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# div-3
# -1/1
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x1
addiu $t1,$t1,0x1

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
ffffffff
========
```

```assembly
# div-4
# -1234/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x1234
addiu $t1,$t1,0x0

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
xxxxxxxx
========
```

```assembly
# div-4
# -1234/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x1234
addiu $t1,$t1,0x0

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
xxxxxxxx
========
```

```assembly
# div-5
# 1234/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x1234
addiu $t1,$t1,0x0

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
xxxxxxxx
========
```

```assembly
# div-5
# 1234/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x1234
addiu $t1,$t1,0x0

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
xxxxxxxx
========
```

```assembly
# div-6
# -7/3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x7
addiu $t1,$t1,0x3

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
ffffffff
========
```

```assembly
# div-6
# -7/3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x7
addiu $t1,$t1,0x3

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
fffffffe
========
```

```assembly
# div-7
# 7/-3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x7
addiu $t1,$t1,-0x3

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000001
========
```

```assembly
# div-7
# 7/-3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x7
addiu $t1,$t1,-0x3

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
fffffffe
========
```

```assembly
# div-8
# -7/-3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x7
addiu $t1,$t1,-0x3

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
ffffffff
========
```

```assembly
# div-8
# -7/-3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,-0x7
addiu $t1,$t1,-0x3

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
00000002
========
```

```assembly
# div-9
# 0/-12
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,-0xc

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# div-9
# 0/-12
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,-0xc

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# div-10
# 0/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,0x0

div $t0,$t1

mfhi $v0

jr $ra

# v0 ref
xxxxxxxx
========
```

```assembly
# div-10
# 0/0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0
# s0 = 0xbfc00400

addiu $t0,$t0,0x0
addiu $t1,$t1,0x0

div $t0,$t1

mflo $v0

jr $ra

# v0 ref
xxxxxxxx
========
```

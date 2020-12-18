# Test bench for `mult`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|10'b0000000000|6b'011000

#### Description

HI, LO <= GPR[rs] * GPR[rt]

#### Edge cases

positive * positive
positive * negative
positive * zero

negative * negative
negative * zero

#### Test cases

```assembly
# mult-1
# 0*0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

addiu $t0,$t0,0x0
addiu $t1,$t1,0x0
mult $t0,$t1
mfhi $s2
sw $s2,0x0($s0)
mflo $s1
sw $s1,0x4($s0)
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
# mult-2
# 0x12345678 * 0x12345678
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0x1234
addiu $t0,$t0,0x5678
lui $t1,0x1234
addiu $t1,$t1,0x5678

mult $t0,$t1

mfhi $s2
sw $s2,0x0($s0)

mflo $s1
sw $s1,0x4($s0)

jr $ra

# v0 ref
bfc00400
========

# data ref
014b66dc
1df4d840
========
```

```assembly
# mult-3
# -0x12345678 * 0x12345678
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678

lui $t1,0x1234
addiu $t1,$t1,0x5678 # $t1 = 0x12345678

mult $t0,$t1

mfhi $s2
sw $s2,0x0($s0)

mflo $s1
sw $s1,0x4($s0)

jr $ra

# v0 ref
bfc00400
========

# data ref
feb49923
e20b27c0
========
```

```assembly
# mult-4
# -0x12345678 * 0x0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678

addiu $t1,$t1,0x0

mult $t0,$t1

mfhi $s2
sw $s2,0x0($s0)

mflo $s1
sw $s1,0x4($s0)

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
# mult-5
# 0x12345678 * 0x0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x1234
addiu $t0,$t0,0x5678 # $t0 = 0x12345678

addiu $t1,$t1,0x0

mult $t0,$t1

mfhi $s2
sw $s2,0x0($s0)

mflo $s1
sw $s1,0x4($s0)

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
# mult-6
# -0x12345678 * -0x12345678
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678

lui $t1,0xedcb
addiu $t1,$t1,0x54c4
addiu $t1,$t1,0x54c4 # $t0 = 0xedcba988 # -0x12345678

mult $t0,$t1

mfhi $s2
sw $s2,0x0($s0)

mflo $s1
sw $s1,0x4($s0)

jr $ra

# v0 ref
bfc00400
========

# data ref
014b66dc
1df4d840
========
```

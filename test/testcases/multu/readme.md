# Test bench for `multu`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|10'b0000000000|6b'011001

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
# multu-1
# 0*0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

addiu $t0,$t0,0x0
addiu $t1,$t1,0x0
multu $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# multu-1
# 0*0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

addiu $t0,$t0,0x0
addiu $t1,$t1,0x0
multu $t0,$t1

mflo $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# multu-2
# 0x12345678 * 0x12345678
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0x1234
addiu $t0,$t0,0x5678
lui $t1,0x1234
addiu $t1,$t1,0x5678

multu $t0,$t1

mfhi $v0

jr $ra

# v0 ref
014b66dc
========
```

```assembly
# multu-2
# 0x12345678 * 0x12345678
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0x1234
addiu $t0,$t0,0x5678
lui $t1,0x1234
addiu $t1,$t1,0x5678

multu $t0,$t1

mflo $v0

jr $ra

# v0 ref
1df4d840
========
```

```assembly
# multu-3
# -0x12345678 * 0x12345678
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678

lui $t1,0x1234
addiu $t1,$t1,0x5678 # $t1 = 0x12345678

multu $t0,$t1

mfhi $v0

jr $ra

# v0 ref
10e8ef9b
========
```

```assembly
# multu-3
# -0x12345678 * 0x12345678
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678

lui $t1,0x1234
addiu $t1,$t1,0x5678 # $t1 = 0x12345678

multu $t0,$t1

mflo $v0

jr $ra

# v0 ref
e20b27c0
========
```

```assembly
# multu-4
# -0x12345678 * 0x0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678

addiu $t1,$t1,0x0

multu $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# multu-4
# -0x12345678 * 0x0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x54c4
addiu $t0,$t0,0x54c4 # $t0 = 0xedcba988 # -0x12345678

addiu $t1,$t1,0x0

multu $t0,$t1

mflo $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# multu-5
# 0x12345678 * 0x0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x1234
addiu $t0,$t0,0x5678 # $t0 = 0x12345678

addiu $t1,$t1,0x0

multu $t0,$t1

mfhi $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# multu-5
# 0x12345678 * 0x0
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

lui $t0,0xedcb
addiu $t0,$t0,0x1234
addiu $t0,$t0,0x5678 # $t0 = 0x12345678

addiu $t1,$t1,0x0

multu $t0,$t1

mflo $v0

jr $ra

# v0 ref
00000000
========
```

```assembly
# multu-6
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

multu $t0,$t1

mfhi $v0

jr $ra

# v0 ref
dce2b9ec
========
```

```assembly
# multu-6
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

multu $t0,$t1

mflo $v0

jr $ra

# v0 ref
1df4d840
========
```

# Test bench for `mtlo`

#### Instruction format

6'b000000|10'b0000000000|5'b<rd>|5'b00000|6b'010000

#### Description

GPR[rd] <- HI

#### Edge cases

#### Test cases

```assembly
# mtlo-1
# 0x0
addiu $t0,$t0,0x0
mtlo $t0
nop
nop
mflo $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# mtlo-2
# -0x1
addiu $t0,$t0,-0x1
mtlo $t0
nop
nop
mflo $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
ffffffff
========
```

```assembly
# mtlo-3
# 0x8000
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
mtlo $t0
nop
nop
mflo $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
00008000
========
```

```assembly
# mtlo-4
# 0xffff0000
lui $t0,0xffff
mtlo $t0
nop
nop
mflo $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
ffff0000
========
```

```assembly
# mtlo-5
# 0x80000000
lui $t0,0x8000
mtlo $t0
nop
nop
mflo $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
80000000
========
```

```assembly
# mtlo-6
# lo do not affect hi
addiu $t2,$t2,0x1234
mthi $t2
nop
lui $t0,0x8000
mtlo $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
00001234
========
```

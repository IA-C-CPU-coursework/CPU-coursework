# Test bench for `mthi`

#### Instruction format

6'b000000|10'b0000000000|5'b<rd>|5'b00000|6b'010000

#### Description

GPR[rd] <- HI

#### Edge cases

#### Test cases

```assembly
# mthi-1
# 0x0
addiu $t0,$t0,0x0
mthi $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# mthi-2
# -0x1
addiu $t0,$t0,-0x1
mthi $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
ffffffff
========
```

```assembly
# mthi-3
# 0x8000
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
mthi $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
00008000
========
```

```assembly
# mthi-4
# 0xffff0000
lui $t0,0xffff
mthi $t0
nop
nop
mfhi $t1
addiu $v0,$t1,0x0
jr $ra

# v0 ref
ffff0000
========
```

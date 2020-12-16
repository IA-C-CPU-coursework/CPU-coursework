# Test bench for `lui`

#### Instruction format

6'b001111|5'b00000|5'b<rt>|16'b<immediate>

#### Description

GPR[rt] <= immediate | 16'b0

#### Edge cases

#### Test cases

```assembly
# lui-1
lui $t0,0x0
addiu $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# lui-2
lui $t0,0xffff
addiu $v0,$t0,0x0
jr $ra

# v0 ref
ffff0000
========
```

```assembly
# lui-3
addiu $t0,$t0,0xffff
lui $t0,0x0
addiu $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========
```

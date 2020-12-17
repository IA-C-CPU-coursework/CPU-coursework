# Test bench for `div`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|10'b0000000000|6b'011010

#### Description

LO <= GPR[rs] div GPR[rt]
HI <= GPR[rs] mod GPR[rt]

#### Edge cases

#### Test cases

```assembly
# div-1
# 5/3
lui $s0,0xbfc0
addiu $s0,$s0,0x400
addiu $v0,$s0,0x0

addiu $t0,$t0,0x5
addiu $t1,$t1,0x3
div $t0,$t1
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

# Test bench for `xor`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|5'b<rd>|5'b00000|5b'100110

#### Description

GPR[rd] <= GPR[rs] xor GPR[rt]

#### Edge cases

#### Test cases

```assembly
# xor-1
# 0=0^0
addiu $t0,$t0,0x0
addiu $t1,$t1,0x0
xor $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# xor-2
# 0=0^1
addiu $t0,$t0,0x0
addiu $t1,$t1,0x1
xor $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# xor-3
# 0b0110=0b1010^0b1010
lui $t0,0xcccc
addiu $t0,$t0,0x5555
addiu $t0,$t0,0x7777
lui $t1,0xaaaa
addiu $t1,$t1,0x3333
addiu $t1,$t1,0x7777
xor $v0,$t0,$t1
jr $ra

# v0 ref
66666666
========
```

```assembly
# xor-4
# 0=0^0x8000
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1
xor $v0,$t0,$t1
jr $ra

# v0 ref
00008000
========
```

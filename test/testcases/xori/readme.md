# Test bench for `xori`

#### Instruction format

6'b001110|5'b<rs>|5'b<rt>|16b'immediate

#### Description

GPR[rd] <= GPR[rs] xor zero_extend(immediate)

#### Edge cases

#### Test cases

```assembly
# xori-1
# 0=0^0
addiu $t0,$t0,0x0
xori $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# xori-2
# 0=0^1
addiu $t0,$t0,0x0
xori $v0,$t0,0x1
jr $ra

# v0 ref
00000001
========
```

```assembly
# xori-3
# 0b0110=0b1010^0b1010
lui $t0,0xcccc
addiu $t0,$t0,0x5555
addiu $t0,$t0,0x7777
xori $v0,$t0,0xaaaa
jr $ra

# v0 ref
cccc6666
========
```

```assembly
# xori-4
# 0=0^0x8000
xori $v0,$t0,0x8000
jr $ra

# v0 ref
00008000
========
```

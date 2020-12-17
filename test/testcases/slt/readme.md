# Test bench for `slt`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|5'b<rd>|5'b00000|5b'101010

#### Description

GPR[rd] <= GPR[rs] < GPR[rt]

#### Edge cases


#### Test cases

```assembly
# slt-1
# 0 = 0 < 0

slt $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# slt-2
# 1 = 0 < 1

addiu $t1,$t1,0x1
slt $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# slt-3
# 1 = -1 <0

addiu $t0,$t0,-0x1
slt $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# slt-4
# 0 = 1 < -1

addiu $t0,$t0,0x1
addiu $t1,$t1,-0x1
slt $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# slt-5
# 0 = 0x7fffffff < 0xffffffff

lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1 # $t0 = 0x7fffffff

addiu $t1,$t1,-0x1
slt $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

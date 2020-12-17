# Test bench for `slti`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|16b'immediate

#### Description

GPR[rd] <= GPR[rs] < sign_extended(immediate)

#### Edge cases


#### Test cases

```assembly
# slti-1
# 0 = 0 < 0

slti $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# slti-2
# 1 = 0 < 1

slti $v0,$t0,0x1
jr $ra

# v0 ref
00000001
========
```

```assembly
# slti-3
# 1 = -1 <0

addiu $t0,$t0,-0x1
slti $v0,$t0,0x0
jr $ra

# v0 ref
00000001
========
```

```assembly
# slti-4
# 0 = 0 < -1

slti $v0,$t0,0xffff
jr $ra

# v0 ref
00000000
========
```

```assembly
# slti-5
# 0 = 1 < -1

addiu $t0,$t0,0x1
slti $v0,$t0,-0x1
jr $ra

# v0 ref
00000000
========
```

```assembly
# slti-6
# 1 = -1 < 1

addiu $t0,$t0,-0x1
slti $v0,$t0,0x1
jr $ra

# v0 ref
00000001
========
```

```assembly
# slti-7
# 0 = 0xffffffff < 0xffffffff

addiu $t0,$t0,-0x1
slti $v0,$t0,-0x1
jr $ra

# v0 ref
00000000
========
```

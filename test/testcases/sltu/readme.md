# Test bench for `sltu`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|16b'immediate

#### Description

GPR[rd] <= GPR[rs] < sign_extended(immediate)

#### Edge cases


#### Test cases

```assembly
# sltu-1
# 0 = 0 < 0

sltu $v0,$t0,0x0
jr $ra

# v0 ref
00000000
========
```

```assembly
# sltu-2
# 1 = 0 < 1

addiu $t1,$t1,0x1
sltu $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# sltu-3
# 0 = 0xffffffff < 0

addiu $t0,$t0,0xffff
sltu $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# sltu-4
# 1 = 0 < 0xffffffff

addiu $t1,$t1,0xffff
sltu $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# sltu-5
# 1 = 1 < 0xffffffff

addiu $t0,$t0,0x1
addiu $t1,$t1,0xffff
sltu $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

```assembly
# sltu-6
# 0 = 0xffffffff < 1

addiu $t0,$t0,0xffff
addiu $t1,$t1,0x1
sltu $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# sltu-7
# 0 = 0xffffffff < 0xffffffff

addiu $t0,$t0,0xffff
addiu $t1,$t1,0xffff
sltu $v0,$t0,-0x1
jr $ra

# v0 ref
00000000
========
```

```assembly
# sltu-8
# 1 = 0x7fffffff < 0xffffffff

lui $t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x7fff
addiu $t0,$t0,0x1

addiu $t1,$t1,0xffff
sltu $v0,$t0,$t1
jr $ra

# v0 ref
00000001
========
```

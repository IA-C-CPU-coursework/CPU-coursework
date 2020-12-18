# Test bench for `sll`

#### Instruction format

6'b000000|5'b00000|5'b<rt>|5'b<rd>|5'b<sa>|5'b00000|

#### Description

GPR[rd] <= GPR[rs] << GPR[rt]

#### Edge cases

sa: 0x11111 0x00000

#### Test cases

```assembly
# sll-1
# 0x1 = 0x1 << 0x0
addiu $t0,$t0,0x1
sll $v0,$t0,0x0
jr $ra

# v0 ref
00000001
========
```

```assembly
# sll-2
# 0x2 = 0x1 << 0x1
addiu $t0,$t0,0x1
sll $v0,$t0,0x1
jr $ra

# v0 ref
00000002
========
```

```assembly
# sll-3
# 0x80000000 = 0x1 << 0x1f
addiu $t0,$t0,0x1
sll $v0,$t0,0x1f
jr $ra

# v0 ref
80000000
========
```

```assembly
# sll-4
# 0x0 = 0x2 << 0x1f
addiu $t0,$t0,0x2
sll $v0,$t0,0x1f
jr $ra

# v0 ref
00000000
========
```

```assembly
# sll-5
# 0xfffffffe = 0xffffffff << 0x1
addiu $t0,$t0,0xffff
sll $v0,$t0,0x1
jr $ra

# v0 ref
fffffffe
========
```

```assembly
# sll-6
# 0x1 = 0xffffffff << 0x1f
addiu $t0,$t0,0xffff
sll $v0,$t0,0x1f
jr $ra

# v0 ref
80000000
========
```


```assembly
# sll-7
# 0x8000 = 0x1 << 0xf
addiu $t0,$t0,0x1
sll $v0,$t0,0xf
jr $ra

# v0 ref
00008000
========
```


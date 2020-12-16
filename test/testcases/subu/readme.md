# Test bench for `subu`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|5'b<rd>|5'b00000|5b'100011

#### Description

temp <= GPR[rs] - GPR[rt]
GPR[rd] <= temp

#### Edge cases

GPR[rs] + GPR[rt] = 0x8000

#### Test cases

```assembly
subu 1
# 0=0-0
addiu $t0,$zero,0x0
addiu $t1,$zero,0x0
subu $v0,$t1,$t0
jr $ra

# v0 ref
00000000
========
```

```assembly
subu 2
# -1=0-1
addiu $t0,$zero,0x0
addiu $t1,$zero,0x1
subu $v0,$t0,$t1
jr $ra

# v0 ref
ffffffff
========
```

```assembly
subu 3
# -1=-1-0
addiu $t0,$zero,-0x1
addiu $t1,$zero,0x0
subu $v0,$t0,$t1
jr $ra

# v0 ref
ffffffff
========
```

```assembly
subu 4
# 0=1-1
addiu $t0,$zero,0x1
addiu $t1,$zero,0x1
subu $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

```assembly
# subu 5
# 0x8000=0x8001-1
addiu $t0,$zero,0x7fff
addiu $t0,$t0,0x2
addiu $t1,$zero,0x1
subu $v0,$t0,$t1
jr $ra

# v0 ref
00008000
========
```

```assembly
# subu 6
# 0x8000=0x7fff-(-1)
addiu $t0,$zero,0x7fff
addiu $t1,$zero,-0x1
subu $v0,$t0,$t1
jr $ra

# v0 ref
00008000
========
```

```assembly
# subu 7
# 0x0=-1-(-1)
addiu $t0,$zero,-0x1
addiu $t1,$zero,-0x1
subu $v0,$t0,$t1
jr $ra

# v0 ref
00000000
========
```

# Test bench for `addu`

#### Instruction format

6'b000000|5'b<rs>|5'b<rt>|5'b<rd>|5'b00000|5b'100001

#### Description

temp <= GPR[rs] + GPR[rt]
GPR[rd] <= sign_extend(temp31..0)

#### Edge cases

GPR[rs] + GPR[rt] = 0x8000

#### Test cases

```assembly
# addu 1
# 0=0+0
addiu $t0,$zero,0x0
addiu $t1,$zero,0x0
addu $v0,$t1,$t0
jr $ra

# v0 ref
00000000
========
```

```assembly
# addu 2
# 1=0+1
addiu $t0,$zero,0x0
addiu $t1,$zero,0x1
addu $v0,$t1,$t0
jr $ra

# v0 ref
00000001
========
```

```assembly
# addu 3
# 0=-1+0
addiu $t0,$zero,-0x1
addiu $t1,$zero,0x0
addu $v0,$t1,$t0
jr $ra

# v0 ref
ffffffff
========
```

```assembly
# addu 4
# 0=-1+1
addiu $t0,$zero,-0x1
addiu $t1,$zero,0x1
addu $v0,$t1,$t0
jr $ra

# v0 ref
00000000
========
```

```assembly
# addu 5
# 0x8000=0x7fff+0x1
addiu $t0,$zero,0x7fff
addiu $v0,$zero,0x0
addiu $t1,$zero,0x1
addiu $v0,$zero,0x0
addu $v0,$t1,$t0
jr $ra

# v0 ref
00008000
========
```

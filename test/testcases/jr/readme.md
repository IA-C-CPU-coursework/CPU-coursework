# Test bench for `jr`

#### Instruction format

6'b000000|5'n<rs>|15'b000000000000000|6'b001000

#### Description


PC <- GPR[rs]

#### Edge cases


#### Test cases

```assembly
# jr-1

lui $t1,0xbfc0
addiu $t1,$t1,0x14
jr $t1
addiu $v0,$v0,0x1
addiu $v0,$v0,0x10

target:
addiu $v0,$v0,0x100
jr $zero

# v0 ref
00000101
========
```

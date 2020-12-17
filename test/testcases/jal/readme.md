# Test bench for `jal`

#### Instruction format



#### Description



#### Edge cases



#### Test cases

```assembly
# for jump instruction
jal labela
addiu $v0,$v0,0x0055
jr $zero
labela:addiu $v0,$zero,0x00aa
jr $ra


# v0 ref
000000aa
========

# data init
========

# data ref
========
```
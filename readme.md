# ELEC50010 MIPS32 CPU Coursework

## Architecture Overview

![mips32_arch-MIPS_CPU_DATA_PATH](https://ouikujie-images.oss-cn-shanghai.aliyuncs.com/img/20201130072005.svg)

## Instruction in details

```
//-----------------------------------------------------------------------------
// Arithmetic Logic Unit
//-----------------------------------------------------------------------------
ADDU    rd, rs, rt      3    Unsigned                        rd = rs + rt (unsigned)
ADDIU   rt, rs, imm     3    Immediate Unsigned              rt = rs + imm[15:0]
AND     rd, rs, rt      3    And                             rd = rs & rt
ANDI    rt, rs, imm     3    And Immediate                   rt = rs & imm[31:0]
LUI     rt, imm         2    Load Upper Immediate            rt = imm[31:0] << 16
OR      rd, rs, rt      3    Or                              rd = rs | rt
ORI     rt, rs, imm     3    Or Immediate                    rt = rs | imm[31:0]
SLT     rd, rs, rt      3    Set on Less Than                rd = rs < rt
SLTI    rt, rs, imm     3    Set on Less Than Immediate      rt = rs < imm[31:0]
SLTIU   rt, rs, imm     3    Set on < Immediate Unsigned     rt = rs < imm[15:0]
SLTU    rd, rs, rt      3    Set On Less Than Unsigned       rd = rs < rt
SUBU    rd, rs, rt      3    Subtract                        rd = rs - rt (unsigned)
XOR     rd, rs, rt      3    Exclusive Or                    rd = rs ^ rt
XORI    rt, rs, imm     3    Exclusice Or Immediate          rt = rs ^ imm


//-----------------------------------------------------------------------------
// Shift
//-----------------------------------------------------------------------------
SLL     rd, rt, sa      3    Shift Left Logical              rd = rt << sa
SLLV    rd, rt, rs      3    Shift Left Logical Variable     rd = rt << rs
SRA     rd, rt, sa      3    Shift Right Arithmetic          rd = rt >> sa 
SRAV    rd, rt, rs      3    Shift Right Arithmetic          rd = rt >> rs
SRL     rd, rt, sa      3    Shift Right Logical             rd = rt >> sa
SRLV    rd, rt, rs      3    Shift Right Logical Variable    rd = rt >> rs


//-----------------------------------------------------------------------------
// Multiply
//-----------------------------------------------------------------------------
DIV     rs, rt          3    Divide                          HI = rs % rt; LO = rs / rt (signed)
DIVU    rs, rt          3    Divide Unsigned                 HI = rs % rt; LO = rs / rt (unsigned)
MTHI    rs              3    Move to HI                      HI = rs
MTLO    rs              3    Move to LO                      LO = rs
MULT    rs, rt          3    Multiply                        HI, LO = rs * rt (signed)
MULTU   rs, rt          3    Multiply Unsigned               HI, LO = rs * rt (unsigned)


//-----------------------------------------------------------------------------
// Branch
//-----------------------------------------------------------------------------
BEQ     rs, rt, offset  2    Branch On Equal                 pc = (rs == rt) ? (pc + offset*4) : (pc + 4)
BGEZ    rs, offset      2    Branch On >= 0                  pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)
BGEZAL  rs, offset      2    Branch On >= 0 And Link         reg[31] = pc; 
                                                             pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)
BFTZ    rs, offset      2    Branch On >  0                  pc = (rs > 0) ? (pc + offset*4) : (pc + 4)
BLEZ    rs, offset      2    Branch On <= 0                  pc = (rs <= 0) ? (pc + offset*4) : (pc + 4)
BLTZ    rs, offset      2    Branch On <  0                  pc = (rs < 0) ? (pc + offset*4) : (pc + 4)
BLTZAL  rs, offset      2    Branch On <  0 And Link         reg[31] = pc; 
                                                             pc = (rs < 0) ? (pc + offset*4) : (pc + 4)
BNE     rs, offset      2    Branch On not equal             pc = (rs != rt) ? (pc + offset*4) : (pc + 4)
J       target          2    Jump                            pc = pc[31:28] | (target << 2)
JAL     target          2    Jump And Link                   reg[31] = pc; pc = pc[31:28] | (target << 2)
JALR    rs              3    Jump And Link Register          rd = pc; pc = rs
JR      rs              2    Jump Register                   pc = rs 


//-----------------------------------------------------------------------------
// Memory Access
//-----------------------------------------------------------------------------
LB      rt, offset(rs)  3    Load Byte                       rt[31:00] = {24{mem[rs + offset][7]}, mem[rs + offset]}
LBU     rt, offset(rs)  3    Load Byte Unsigned              rt[31:00] = {24{0}, mem[rs + offset]}
LH      rt, offset(rs)  3    Load Halfword                   rt[31:00] = {16{mem[rs + offset]}, mem[rs + offset]}
                             half aligned word
LHU     rt, offset(rs)  3    Load Halfword Unsigned          rt[31:00] = {16[0], mem[rs + offset]}
LUI     rt, imm         3    Load Upper Immediate            rt[31:00] = immediate << 16
LW      rt, offset(rs)  3    Load Word                       rt[31:00] = mem[rs + offset]
LWL     rt, offset(rs)  3    Load Word Left                  rt[31:16] = mem[rs + offset]
                             possibly unaligned word        
LWR     rt, offset(rs)  3    Load Word Right                 rt[15:00] = mem[rs + offset]
                             possibly unaligned word        
SB      rt, offset(rs)  3    Store Byte                      mem[rs + offset] = rt[07:00]
SH      rt, offset(rs)  3    Store Halfword                  mem[rs + offset] = rt[15:00]
                             aligned location
SW      rt, offset(rs)  3    Store Word                      mem[rs + offset] = rt[31:00]
```

For `MULT`, maybe we need two `write_addr` on `RegFile` to write `HI` and `LO` at the same time?   


# ELEC50010 MIPS32 CPU Coursework

## Architecture Overview

![mips32_arch-MIPS_CPU](https://ouikujie-images.oss-cn-shanghai.aliyuncs.com/img/20201129045413.svg)



#### PCGenerator

![mips32_arch-PCGenerator](https://ouikujie-images.oss-cn-shanghai.aliyuncs.com/img/20201129045620.svg)

## Instruction in details

```
//-----------------------------------------------------------------------------
// Arithmetic Logic Unit
//-----------------------------------------------------------------------------
ADDU    rd, rs, rt      Unsigned                        rd = rs + rt (unsigned)
ADDIU   rt, rs, imm     Immediate Unsigned              rt = rs + imm[15:0]
AND     rd, rs, rt      And                             rd = rs & rt
ANDI    rt, rs, imm     And Immediate                   rt = rs & imm[31:0]
LUI     rt, imm         Load Upper Immediate            rt = imm[31:0] << 16
OR      rd, rs, rt      Or                              rd = rs | rt
ORI     rt, rs, imm     Or Immediate                    rt = rs | imm[31:0]
SLT     rd, rs, rt      Set on Less Than                rd = rs < rt
SLTI    rt, rs, imm     Set on Less Than Immediate      rt = rs < imm[31:0]
SLTIU   rt, rs, imm     Set on < Immediate Unsigned     rt = rs < imm[15:0]
SLTU    rd, rs, rt      Set On Less Than Unsigned       rd = rs < rt
SUBU    rd, rs, rt      Subtract                        rd = rs - rt (unsigned)
XOR     rd, rs, rt      Exclusive Or                    rd = rs ^ rt
XORI    rt, rs, imm     Exclusice Or Immediate          rt = rs ^ imm


//-----------------------------------------------------------------------------
// Shift
//-----------------------------------------------------------------------------
SLL     rd, rt, sa      Shift Left Logical              rd = rt << sa
SLLV    rd, rt, sa      Shift Left Logical Variable     rd = rt << rs
SRA     rd, rt, sa      Shift Right Arithmetic          rd = rt >> sa 
SRAV    rd, rt, sa      Shift Right Arithmetic          rd = rt >> rs
SRL     rd, rt, sa      Shift Right Logical             rd = rt >> sa
SRLV    rd, rt, sa      Shift Right Logical Variable    rd = rt >> rs


//-----------------------------------------------------------------------------
// Multiply
//-----------------------------------------------------------------------------
DIV     rs, rt          Divide                          HI = rs % rt; LO = rs / rt (signed)
DIVU    rs, rt          Divide Unsigned                 HI = rs % rt; LO = rs / rt (unsigned)
MTHI    rs              Move to HI                      HI = rs
MTLO    rs              Move to LO                      LO = rs
MULT    rs, rt          Multiply                        HI, LO = rs * rt (signed)
MULTU   rs, rt          Multiply Unsigned               HI, LO = rs * rt (unsigned)


//-----------------------------------------------------------------------------
// Branch
//-----------------------------------------------------------------------------
BEQ     rs, rt, offset  Branch On Equal                 pc = (rs == rt) ? (pc + offset*4) : (pc + 4)
BGEZ    rs, offset      Branch On >= 0                  pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)
BGEZAL  rs, offset      Branch On >= 0 And Link         reg[31] = pc; pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)
BFTZ    rs, offset      Branch On >  0                  pc = (rs > 0) ? (pc + offset*4) : (pc + 4)
BLEZ    rs, offset      Branch On <= 0                  pc = (rs <= 0) ? (pc + offset*4) : (pc + 4)
BLTZ    rs, offset      Branch On <  0                  pc = (rs < 0) ? (pc + offset*4) : (pc + 4)
BLTZAL  rs, offset      Branch On <  0 And Link         reg[31] = pc; pc = (rs < 0) ? (pc + offset*4) : (pc + 4)
BNE     rs, offset      Branch On not equal             pc = (rs != rt) ? (pc + offset*4) : (pc + 4)
J       target          Jump                            pc = pc[31:28] | (target << 2)
JAL     target          Jump And Link                   reg[31] = pc; pc = target << 2
JALR    rs              Jump And Link Register          rd = pc; pc = rs
JR      rs              Jump Register                   pc = rs 


//-----------------------------------------------------------------------------
// Memory Access
//-----------------------------------------------------------------------------
LB      rt, offset(rs)  Load Byte                       rt[31:00] = {24{mem[rs + offset][7]}, mem[rs + offset]}
LBU     rt, offset(rs)  Load Byte Unsigned              rt[31:00] = {24{0}, mem[rs + offset]}
LH      rt, offset(rs)  Load Halfword                   rt[31:00] = {16{mem[rs + offset]}, mem[rs + offset]}
                        half aligned word
LHU     rt, offset(rs)  Load Halfword Unsigned          rt[31:00] = {16[0], mem[rs + offset]}
LUI     rt, imm         Load Upper Immediate            rt[31:00] = immediate << 16
LW      rt, offset(rs)  Load Word                       rt[31:00] = mem[rs + offset]
LWL     rt, offset(rs)  Load Word Left                  rt[31:16] = mem[rs + offset]
                        possibly unaligned word        
LWR     rt, offset(rs)  Load Word Right                 rt[15:00] = mem[rs + offset]
                        possibly unaligned word        
SB      rt, offset(rs)  Store Byte                      mem[rs + offset] = rt[07:00]
SH      rt, offset(rs)  Store Halfword                  mem[rs + offset] = rt[15:00]
                        aligned location
SW      rt, offset(rs)  Store Word                      mem[rs + offset] = rt[31:00]
```


# ELEC50010 MIPS32 CPU Coursework

## Architecture Overview

![mips32_arch-MIPS_CPU](https://ouikujie-images.oss-cn-shanghai.aliyuncs.com/img/20201206023720.svg)



## Instruction in details

```
//-----------------------------------------------------------------------------
//                        MIPS Instruction Format
//-----------------------------------------------------------------------------

+---+--------+--------+-------------+--------+--------------+-----------+
|   | 6 bits | 5 bits |    5 bits   | 5 bits |    5 bits    |  6 bits   |
+---+--------+--------+-------------+--------+--------------+-----------+
| R | opcode | rs     | rt          | rd     | shift amount | func code |
+---+--------+--------+-------------+--------+--------------+-----------+
| I | opcode | rs     | rt          | immediate                         |
+---+--------+--------+-------------+-----------------------------------+
| J | opcode | address                                                  |
+---+--------+----------------------------------------------------------+


//-----------------------------------------------------------------------------
// Arithmetic Logic Unit
//-----------------------------------------------------------------------------
ADDU    rd, rs, rt      2    Unsigned                        rd = rs + rt (unsigned)
ADDIU   rt, rs, imm     2    Immediate Unsigned              rt = rs + imm[15:0]
AND     rd, rs, rt      2    And                             rd = rs & rt
ANDI    rt, rs, imm     2    And Immediate                   rt = rs & imm[31:0]
LUI     rt, imm         2    Load Upper Immediate            rt = imm[31:0] << 16
OR      rd, rs, rt      2    Or                              rd = rs | rt
ORI     rt, rs, imm     2    Or Immediate                    rt = rs | imm[31:0]
SLT     rd, rs, rt      2    Set on Less Than                rd = rs < rt
SLTI    rt, rs, imm     2    Set on Less Than Immediate      rt = rs < imm[31:0]
SLTIU   rt, rs, imm     2    Set on < Immediate Unsigned     rt = rs < imm[15:0]
SLTU    rd, rs, rt      2    Set On Less Than Unsigned       rd = rs < rt
SUBU    rd, rs, rt      2    Subtract                        rd = rs - rt (unsigned)
XOR     rd, rs, rt      2    Exclusive Or                    rd = rs ^ rt
XORI    rt, rs, imm     2    Exclusice Or Immediate          rt = rs ^ imm


//-----------------------------------------------------------------------------
// Shift
//-----------------------------------------------------------------------------
SLL     rd, rt, sa      2    Shift Left Logical              rd = rt << sa
SLLV    rd, rt, rs      2    Shift Left Logical Variable     rd = rt << rs
SRA     rd, rt, sa      2    Shift Right Arithmetic          rd = rt >> sa 
SRAV    rd, rt, rs      2    Shift Right Arithmetic Variable rd = rt >> rs
SRL     rd, rt, sa      2    Shift Right Logical             rd = rt >> sa
SRLV    rd, rt, rs      2    Shift Right Logical Variable    rd = rt >> rs


//-----------------------------------------------------------------------------
// Multiply
//-----------------------------------------------------------------------------
DIV     rs, rt          2    Divide                          HI = rs % rt; LO = rs / rt (signed)
DIVU    rs, rt          2    Divide Unsigned                 HI = rs % rt; LO = rs / rt (unsigned)
MTHI    rs              2    Move to HI                      HI = rs
MTLO    rs              2    Move to LO                      LO = rs
MULT    rs, rt          2    Multiply                        HI, LO = rs * rt (signed)
MULTU   rs, rt          2    Multiply Unsigned               HI, LO = rs * rt (unsigned)


//-----------------------------------------------------------------------------
// Branch
//-----------------------------------------------------------------------------
BEQ     rs, rt, offset  2    Branch On Equal                 pc = (rs == rt) ? (pc + offset*4) : (pc + 4)
BGEZ    rs, offset      2    Branch On >= 0                  pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)
BGEZAL  rs, offset      2    Branch On >= 0 And Link         reg[31] = pc; 
                                                             pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)
BGTZ    rs, offset      2    Branch On >  0                  pc = (rs > 0) ? (pc + offset*4) : (pc + 4)
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
SB      rt, offset(rs)  2    Store Byte                      mem[rs + offset] = rt[07:00]
SH      rt, offset(rs)  2    Store Halfword                  mem[rs + offset] = rt[15:00]
                             aligned location
SW      rt, offset(rs)  2    Store Word                      mem[rs + offset] = rt[31:00]
```

### Decoder Control Signals

**Multiplexers**: MemSrc, RegSrc, RegData, ALUSrc 

**Storage**: MemWrite, MemRead, ByteEn, RegWrite, CntEn

**ALU**: ALUControl

**PC**: PCControl



##### MemWrite

enable write to memory when asserted

##### MemRead

enable read to memory when asserted

##### ByteEn 

`byteenable` signal for Avalon memory

##### RegWrite

enable write to register file when asserted

##### CntEn 

enable write to Program Counter when asserted 

##### MemSrc

```verilog
mem_addr[31:0] = MemSrc ? pc[31:0] : alu_result[31:0];
```

##### RegSrc 

```verilog
write_addr[4:0] = RegSrc ? (rt)mem_out[20:16] : (rd)mem_out[15:11]; 
```

##### ALUSrc1

```verilog
alu_src_1 = ALUSrc1 ? shift_amount : read_data_1;
```

##### ALUSrc2

```verilog
alu_src_2 = ALUSrc2 ? signed_offset : read_data_2;
```

##### RegData[1:0]

```verilog
case(RegData) begin
    2'b00: assign write_data = mem_out;
    2'b01: assign write_data = mem_addr;
    2'b10: assign write_data = alu_result;
end
```

##### PCControl[1:0] 

```verilog
if (CntEn) begin
    case(PCControl) begin
        2'b00: pc[31:0] <= pc[31:0]  + offset[15:0] << 2;
        2'b01: pc[31:0] <= pc[31:28] + target << 2;
        2'b10: pc[31:0] <= rs[31:0];
        2'b11: pc[31:0] <= pc[31:0]  + 4;
    end
end
```

##### ALUControl[4:0]

```verilog
case(ALUControl) begin
    5'b00000: alu_result[31:0] = alu_src_1[31:0] +   alu_src_2[31:0]; // unsigned add
    5'b00001: alu_result[31:0] = alu_src_1[31:0] &   alu_src_2[31:0]; // and
    5'b00010: HI              <= alu_src_1[31:0] %   alu_src_2[31:0]; // divide
              LO              <= alu_src_1[31:0] /   alu_src_2[31:0]; // divide
    5'b00011: branch           = alu_src_1[31:0] ==  alu_src_2[31:0]; // equal to
    5'b00100: branch           = alu_src_1[31:0] >   alu_src_2[31:0]; // greater than 
    5'b00101: branch           = alu_src_1[31:0] >=  alu_src_2[31:0]; // greater than or equal to 
    5'b00110: branch           = alu_src_1[31:0] <   alu_src_2[31:0]; // less than 
    5'b00111: branch           = alu_src_1[31:0] <=  alu_src_2[31:0]; // less than or equal to 
    5'b01000: HI, LO          <= alu_src_1[31:0] *   alu_src_2[31:0]; // multiply
    5'b01001: branch           = alu_src_1[31:0] !=  alu_src_2[31:0]; // not equal to 
    5'b01010: alu_result[31:0] = alu_src_1[31:0] |   alu_src_2[31:0]; // or 
    5'b01011: alu_result[31:0] = alu_src_1[31:0] <<  alu_src_2[31:0]; // shift to left logic 
    5'b01100: alu_result[31:0] = alu_src_1[31:0] >>  alu_src_2[31:0]; // shift to right arithmetic 
    5'b01101: alu_result[31:0] = alu_src_1[31:0] >>> alu_src_2[31:0]; // shift to right logic 
    5'b01110: alu_result[31:0] = alu_src_1[31:0] -   alu_src_2[31:0]; // subtract
    5'b01111: alu_result[31:0] = alu_src_1[31:0] ^   alu_src_2[31:0]; // xor
    5'b10000: HI              <= alu_result[31:0];                    // Move to HI
    5'b10001: alu_result[31:0] = HI;                                  // Move from HI
    5'b10010: LO              <= alu_result[31:0];                    // Move to LO
    5'b10011: alu_result[31:0] = LO;                                  // Move from LO
    5'b10100: alu_result[31:0] = alu_src_1[31:0] << 16;				  // shift the lower half word to upper half
end
```



### State Machine

- FETCH
- EXEC1
- EXEC2

##### State: FETCH

|    | Instr | MemSrc | MemWrite | MemRead | ByteEn | RegSrc | RegData | RegWrite | PCControl | CntEn | ALUSrc1 | ALUSrc2 | ALUControl |
| -- | ----- | ------ | -------- | ------- | ------ | ------ | ------- | -------- | --------- | ----- | ------ | ---------- | ---------- |
| ✅ | x     | 1      | 0        | 1       | 1111   | x      | x       | 0        | xx        | 0     | x     | x    | x          |

##### State: EXEC1

|    | Instr | MemSrc | MemWrite | MemRead | ByteEn | RegSrc | RegData | RegWrite | PCControl | CntEn | ALUSrc1 | ALUSrc2 | ALUControl |
| -- | ----- | ------ | -------- | ------- | ------ | ------ | ------- | -------- | --------- | ----- | ------ | ---------- | ---------- |
| ✅ | ADDIU | 1      | 0        | 0       | 1111   | 1      | 10      | 1        | 11        | 1     | 0    | 1   | 00000      |
| ✅ | ADDU  | 1      | 0        | 0       | 1111   | 0     | 10      | 1        | 11        | 1     | 0   | 0  | 00000      |
| ✅ | LW    | 0     | 0        | 1       | 1111   | x      | xx      | 0        | xx        | 0     | 0     | 1    | 00000      |
| ✅ | LUI   | 1      | 0        | 0       | 1111   | 1      | 10      | 1        | 11        | 1     | 0 | 1 | 10100 |
| ✅ | SW    | 0      | 1        | 0       | 1111   | x      | xx      | 0        | 11       | 1     | 0   | 1   | 00000      |
| ✅ | JR    | 1      | 0        | 0       | 1111   | x      | xx      | 0        | 10        | 1     | 0    | x    | xxxxx      |
| ❌ | J     | 1      | 0        | 0       | 1111   | x      | xx      | 0        | 01        | 1     | 0    | x    | xxxxx      |
| ✅ | SLL   | 1      | 0        | 0       | 1111   | 1      | 10      | 1        | 11        | 1     | 1    | 0   | 01011      |
| ✅ | SLLV | 1 | 0 | 0 | 1111 | 1 | 10 | 1 | 11 | 1 | 0 | 0 | 01011 |
| ✅ | SRA | 1 | 0 | 0 | 1111 | 1 | 10 | 1 | 11 | 1 | 1 | 0 | 01100 |
| ✅ | SRAV | 1 | 0 | 0 | 1111 | 1 | 10 | 1 | 11 | 1 | 0 | 0 | 01100 |
| ✅ | SRL | 1 | 0 | 0 | 1111 | 1 | 10 | 1 | 11 | 1 | 1 | 0 | 01101 |
| ✅ | SRLV | 1 | 0 | 0 | 1111 | 1 | 10 | 1 | 11 | 1 | 0 | 0 | 01101 |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |
| ✅ | SUBU | 1 | 0 | 0 | 1111 | 0 | 10 | 1 | 11 | 1 | 0 | 0 | 01110 |
| ✅ | AND | 1 | 0 | 0 | 1111 | 0 | 10 | 1 | 11 | 1 | 0 | 0 | 00001 |
| ✅ | OR | 1 | 0 | 0 | 1111 | 0 | 10 | 1 | 11 | 1 | 0 | 0 | 01010 |
| ✅ | XOR | 1 | 0 | 0 | 1111 | 0 | 10 | 1 | 11 | 1 | 0 | 0 | 01111 |

##### State: EXEC2

|    | Instr | MemSrc | MemWrite | MemRead | ByteEn | RegSrc | RegData | RegWrite | PCControl | CntEn | ALUSrc1 | ALUSrc2 | ALUControl |
| -- | ----- | ------ | -------- | ------- | ------ | ------ | ------- | -------- | --------- | ----- | ------ | ---------- | ---------- |
| ✅ | LW    | 1   | 0        | 0      | 1111   | 1     | 00      | 1        | 11        | 1     | 0     | 1    | 00000      |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |
| ❌ |       |        |          |         |        |        |         |          |           |       |        |        |            |

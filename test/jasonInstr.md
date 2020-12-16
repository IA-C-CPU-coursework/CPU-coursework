//-----------------------------------------------------------------------------
// Branch
//-----------------------------------------------------------------------------
BEQ     rs, rt, offset  2    Branch On Equal                 pc = (rs == rt) ? (pc + offset*4) : (pc + 4)  // done
BGEZ    rs, offset      2    Branch On >= 0                  pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)   //done
BGEZAL  rs, offset      2    Branch On >= 0 And Link         reg[31] = pc;    ///NOT WORKING
                                                             pc = (rs >= 0) ? (pc + offset*4) : (pc + 4)  /
BGTZ    rs, offset      2    Branch On >  0                  pc = (rs > 0) ? (pc + offset*4) : (pc + 4)   // done
BLEZ    rs, offset      2    Branch On <= 0                  pc = (rs <= 0) ? (pc + offset*4) : (pc + 4)    //done
BLTZ    rs, offset      2    Branch On <  0                  pc = (rs < 0) ? (pc + offset*4) : (pc + 4)     //done
BLTZAL  rs, offset      2    Branch On <  0 And Link         reg[31] = pc;                                  //done
                                                             pc = (rs < 0) ? (pc + offset*4) : (pc + 4)
BNE     rs, offset      2    Branch On not equal             pc = (rs != rt) ? (pc + offset*4) : (pc + 4)   //done
J       target          2    Jump                            pc = pc[31:28] | (target << 2)
JAL     target          2    Jump And Link                   reg[31] = pc; pc = pc[31:28] | (target << 2)
JALR    rs              3    Jump And Link Register          rd = pc; pc = rs
JR      rs              2    Jump Register                   pc = rs 

 


//-----------------------------------------------------------------------------
// Memory Access
//-----------------------------------------------------------------------------
LB      rt, offset(rs)  3    Load Byte                       rt[31:00] = {24{mem[rs + offset][7]}, mem[rs + offset]} ///done
LBU     rt, offset(rs)  3    Load Byte Unsigned              rt[31:00] = {24{0}, mem[rs + offset]} //done
LH      rt, offset(rs)  3    Load Halfword                   rt[31:00] = {16{mem[rs + offset]}, mem[rs + offset]} //done
                             half aligned word
LHU     rt, offset(rs)  3    Load Halfword Unsigned          rt[31:00] = {16[0], mem[rs + offset]}   //done
LUI     rt, imm         3    Load Upper Immediate            rt[31:00] = immediate << 16  //done
LW      rt, offset(rs)  3    Load Word                       rt[31:00] = mem[rs + offset] //done
LWL     rt, offset(rs)  3    Load Word Left                  rt[31:16] = mem[rs + offset]  //done
                             possibly unaligned word        
                             possibly unaligned word        
SB      rt, offset(rs)  2    Store Byte                      mem[rs + offset] = rt[07:00]   //done
SH  ls    rt, offset(rs)  2    Store Halfword                  mem[rs + offset] = rt[15:00]  //done
                             aligned location
SW      rt, offset(rs)  2    Store Word                      mem[rs + offset] = rt[31:00]    //done
```
 
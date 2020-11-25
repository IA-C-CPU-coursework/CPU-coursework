module mips_cpu_instruction_dec(
    input logic[25:0] instr,
    output logic[5:0] opcode
)
wire OP = instr[25:20];
wire rd = instr[19:15];
wire rs = instr[14:10];
wire rt = instr[9:5];

always @(*)begin
    if(OP =2'b000000) opcode = 1 ; //addiu
    else if(OP = 2'b000001) opcode = 2; //jr
    else if(OP = 2'b000010) opcode = 3; // lw
    else if(OP = 2'b000011) opcode = 4; // sw
end
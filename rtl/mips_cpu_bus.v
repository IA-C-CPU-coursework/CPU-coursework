module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

logic[5:0] opcode;
logic fetch;
logic exec1;
logic exec2;
logic reg_wr;
logic[3:0] ALU_control;
logic ALU_sel;
logic Ram_wr;
logic Mem_to_re;
logic mem_read;
logic branch;
logic jump;
logic reg_dest;
logic extra;
mips_cpu_state states(
    .clk(clk),
    .extra(extra),
    .fetch(fetch),
    .exec1(exec1),
    .exec2(exec2)
);
mips_cpu_control decoder(
    .opcode(opcode),
    .fetch(fetch),
    .exec1(exec1),
    .exec2(exec2),
    .reg_wr(reg_wr),
    .ALU_control(ALU_control),
    .ALU_sel(AlU_sel),
    .Ram_wr(Ram_wr),
    .Mem_to_re(Mem_to_re),
    .mem_read(mem_read),
    .branch(branch),
    .jump(jump),
    .reg_dest(reg_dest),
    .extra(extra)
);




endmodule 
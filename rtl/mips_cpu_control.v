module mips_cpu_control(
    input logic[5:0] opcode,
    input logic fetch,
    input logic exec1,
    input logic exec2,
    // wait for including more instructions
    output logic reg_wr,
    output logic[3:0] ALU_control,
    output logic ALU_sel,
    output logic Ram_wr,
    output logic Mem_to_re,
    output logic mem_read,
    output logic branch,
    output logic jump,
    output logic reg_dest,
    output logic extra
);

wire jr,addiu,lw,sw;

//assign lw = s[25] & ~s[24] & ~s[23] & ~s[22] & s[21] & s[20];
//assign sw = s[25] & ~s[24] & s[23] & ~s[22] & s[21] & s[20];
//assign jr = ~s[25] & ~s[24] & ~s[23] & ~s[22] & ~s[21] & ~s[20];
//assign addiu = ~s[25] & ~s[24] & s[23] & ~s[22] & ~s[21] & s[20];
assign addiu = opcode[0];
assign jr = opcode[1];
assign lw = opcode[2];
assign sw = opcode[3];


assign extra = lw & exec1;
assign Ram_wr = exec1 & sw;
assign reg_wr = exec2 & lw;
assign mem_read = fetch | lw & exec1;
assign ALU_src = addiu & exec1;
assign Mem_to_reg = addiu & exec1;
assign jump = jr & exec1;


if(addiu){
    assign ALU_control = 2'b0010;
}
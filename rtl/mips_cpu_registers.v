module mips_cpu_registers(
    input logic clk,
    input logic write_enable,
    input logic reset,
    input logic[4:0] read_r1,
    input logic[4:0] read_r2,
    input logic[4:0] write_r,
    input logic[31:0] write_data,
    output logic[31:0] data_r1,
    output logic[31:0] data_r2
);

reg[31:0] memory[31:0];

initial begin
    integer i;
    for (i = 0; i < 32; i++)begin
        memory[i] = 0; 
    end
end

always @(reset) begin
    if(reset == 1) begin
        integer i;
        for (i = 0; i < 32; i++)begin
             memory[i] = 0; 
        end 
    end
end

// Use always_ff when simulating flip flops
always @(posedge clk) begin
    if(reset == 0) begin
        memory[write_r] = write_data;
    end
end
    
// I believe that these two lines should be set on posedge clock please correct me if wrong   
assign data_r1 = memory[read_r1];
assign data_r2 = memory[read_r2];

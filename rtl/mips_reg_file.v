module mips_reg_file(
    input rst,
    input clk,
    input RegWrite, // Write enable
    input [4:0] write_addr, // Which Register to write to
    input [4:0] read_addr_1, // Read reg numbers
    input [4:0] read_addr_2,
    input [31:0] write_data, // Data to write to reg
    output [31:0] read_data_1, // Output data for respective registers
    output [31:0] read_data_2,
    output [31:0] v0
);

assign v0 = registers[2];
    
logic [31:0] registers [0:31]; 
//assign registers[0] = 0; // Hardwired to 0
    
// Writing to registers
genvar i;
generate
    for (i=0; i<32; i=i+1) begin
        always_ff @(posedge clk) begin
            if (rst) begin
                registers[i] <= 0; 
            end 
        end
    end
endgenerate
        
        
always_ff @(posedge clk) begin
    if(RegWrite) begin
        if(write_addr!=0) begin
            registers[write_addr] <= write_data;
        end
    end

end  

assign read_data_1 = registers[read_addr_1];
assign read_data_2 = registers[read_addr_2];
    
endmodule

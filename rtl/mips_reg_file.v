module mips_reg_file(
    input rst,
    input CLK,
    input [4:0] WriteAddress, // Which Register to write to
    input RegWrite, // Write enable
    input [31:0] DataIn, // Data to write to reg
    input [4:0] Address1, // Reg numbers
    input [4:0] Address2,
    output [31:0] DataOut1, // Output data for respective registers
    output [31:0] DataOut2

);

    
logic [31:0] registers [0:31]; 
assign registers[0] = 0; // Hardwired to 0
    


integer i;
// Writing to registers
always_ff @(posedge CLK) begin
    if (rst) begin
        for(i=0;i<32;i++) begin
            registers[i] <= 32'h0; 
        end
        
    end
    else if(RegWrite) begin
        if(WriteAddress!=0) begin
            registers[WriteAddress] <= DataIn;
        end
    end

end  

/*
mips_reg_file.v:25: error: array 'registers' index must be a constant in this context.
mips_reg_file.v:31: error: array 'registers' index must be a constant in this context.
2 error(s) during elaboration.
 */
assign DataOut1 = registers[Address1];
assign DataOut2 = registers[Address2];
    
endmodule

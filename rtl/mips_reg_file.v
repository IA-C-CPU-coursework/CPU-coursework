module mips_reg_file(
    input rst,
    input CLK,
    input RegWrite, // Write enable
    input [4:0] WriteAddress, // Which Register to write to
    input [4:0] Address1, // Read reg numbers
    input [4:0] Address2,
    input [31:0] DataIn, // Data to write to reg
    output [31:0] DataOut1, // Output data for respective registers
    output [31:0] DataOut2

);

    
logic [31:0] registers [0:31]; 
//assign registers[0] = 0; // Hardwired to 0
    
// Writing to registers
genvar i;
generate
    for (i=0; i<32; i=i+1) begin
        always_ff @(posedge CLK) begin
            if (rst) begin
                registers[1] <= 0; //Every other way i tried to assign all reg to zero resulted in compile error
            end 
        end
    end
endgenerate
        
        
always_ff @(posedge CLK) begin
    if(RegWrite) begin
        if(WriteAddress!=0) begin
            registers[WriteAddress] <= DataIn;
        end
    end

end  

assign DataOut1 = registers[Address1];
assign DataOut2 = registers[Address2];
    
endmodule

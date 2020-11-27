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
always_ff @(posedge CLK) begin
    if (rst) begin
        registers[1] <= 0; //Every other way i tried to assign all reg to zero resulted in compile error
        registers[2] <= 0;
        registers[3] <= 0;
        registers[4] <= 0;
        registers[5] <= 0;
        registers[6] <= 0;
        registers[7] <= 0;
        registers[8] <= 0;
        registers[9] <= 0;
        registers[10] <= 0;
        registers[11] <= 0;
        registers[12] <= 0;
        registers[13] <= 0;
        registers[14] <= 0;
        registers[15] <= 0;
        registers[16] <= 0;
        registers[17] <= 0;
        registers[18] <= 0;
        registers[19] <= 0;
        registers[20] <= 0;
        registers[21] <= 0;
        registers[22] <= 0;
        registers[23] <= 0;
        registers[24] <= 0;
        registers[25] <= 0;
        registers[26] <= 0;
        registers[27] <= 0;
        registers[28] <= 0;
        registers[29] <= 0;
        registers[30] <= 0;
        registers[31] <= 0;

        
    end
        
        
    if(RegWrite) begin
        if(WriteAddress!=0) begin
            registers[WriteAddress] <= DataIn;
        end
    end

end  

assign DataOut1 = registers[Address1];
assign DataOut2 = registers[Address2];
    
endmodule

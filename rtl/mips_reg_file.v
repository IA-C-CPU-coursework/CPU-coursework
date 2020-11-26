module RegFile(
    input rst;
    input CLK;
    input WriteAddress; // Which Register to write to
    input RegWrite; // Write enable
    input [31:0] DataIn; // Data to write to reg
    input [5:0] Address1; // Reg numbers
    input [5:0] Address2;
    output [31:0] DataOut1; // Output data for respective registers
    output [31:0] DataOut2;

);

    
logic [0:31][31:0] registers; 
assign registers[0] = 0; // Hardwired to 0
    

// When reset is high set all registers to zero    
always_comb begin   
    if (rst) begin
        int i;
        for (i=0;i<32;i++) begin
            registers[i] = 0;
        end  
    end
end

// Writing to registers
always_ff (@posedge CLK) begin
    if(RegWrite) begin
        if(WriteAddress!=0) begin
            registers[WriteAddress] <= DataIn;
            end
        end
    end
    
assign DataOut1 = registers[Address1];
assign DataOut2 = registers[Address2];
    
endmodule

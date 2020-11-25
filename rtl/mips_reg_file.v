module RegFile(
    input CLK;
    input WriteAddress; // Which Register to write to
    input RegWrite; // Write enable
    input [31:0] DataIn; // Data to write to reg
    input [5:0] Address1; // reg numbers
    input [5:0] Address2;
    output [31:0] DataOut1; // output data for respective registers
    output [31:0] DataOut2;

);

logic [31:0][31:0] registers;


always_ff (@posedge CLK) begin
    if(RegWrite) begin
        registers[WriteAddress] <= DataIn;
    end
    if(!RegWrite) begin
        DataOut1 <= registers[Address1];
        DataOut2 <= registers[Address2];
    end
end
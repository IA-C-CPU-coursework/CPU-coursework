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
    
    logic [31:0][31:0] registers;
    logic [31:0] pc;

    wire [5:0] opcode = address[31:26];
    wire [25:0] jump_address = readdata[25:0];

     /* $0 is hardwired to 0 and 31 is a link register */
    assign registers[0] = 0;

    always_comb begin
        
    end
    
    always_ff (@posedge clk) begin
        
    end

endmodule
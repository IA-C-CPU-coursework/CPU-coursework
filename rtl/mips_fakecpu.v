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
    logic[1:0] count;
    initial begin
        active = 1;
        register_v0 = 32'h00000000;
        count = 0;
        address = 0;
        write =0;
        read = 0;
        writedata = 0;
        byteenable = 0;
    end

    always_ff @(posedge clk)begin
        if(count==2)begin
            register_v0 = 32'h00000001;
            active = 0;
        end
        count<= count + 1;
    end


endmodule 
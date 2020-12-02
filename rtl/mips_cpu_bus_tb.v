`include "mips_cpu_bus.v"
`include "RAM_32x64k_avalon.v"


module mips_cpu_bus_tb();

    parameter RAM_INIT_FILE = "../test/binary/RAM_avalon.hex.txt";
    parameter TIMEOUT_CYCLES = 100;

    /* Standard signals */
    logic clk;
    logic reset;
    logic active;
    logic[31:0] register_v0;

    /* Avalon memory mapped bus controller (master) */
    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[3:0] byteenable;
    logic[31:0] readdata;

    logic pending;

    mips_cpu_bus cpu(
        /* Standard signals */
        .clk(clk),        
        .reset(reset),
        .active(active),
        .register_v0(register_v0),

        /* Avalon memory mapped bus controller (master) */
        .address(address),
        .write(write),
        .read(read),
        .waitrequest(waitrequest),
        .writedata(writedata),
        .byteenable(byteenable),
        .readdata(readdata)
    );

    // Instanciation of RAM_32x64k_avalon
    RAM_32x64k_avalon #(RAM_INIT_FILE) ramInst(
        .rst(reset),
        .p(pending),
        .clk(clk),
        .address(address), 
        .write(write), 
        .read(read), 
        .waitrequest(waitrequest), 
        .writedata(writedata), 
        .byteenable(byteenable), 
        .readdata(readdata)
    );

endmodule

module mips_cpu_bus_tb;
timeunit 1ns/10ps;

//the RAM_FILE will change for different testcasese.
parameter RAM_FILE = "../test/01-intruction_hex/01_addiu.txt";
parameter TIMEOUT_CYCLES = 10000;

logic clk;
logic reset;
logic[31:0] register_v0;

logic[31:0] address;
logic write;
logic read;
logic[31:0] writedata;
logic[31:0] readdata;
logic waitrequest;
logic[3:0] byteenable;
logic active;

//create an instance of CPU
mips_cpu_bus CPU(
    .clk(clk),
    .reset(reset),
    .active(active),
    .register_v0(register_v0),
    .address(address),
    .write(write),
    .read(read),
    .waitrequest(waitrequest),
    .writedata(writedata),
    .byteenable(byteenable),
    .readdata(readdata)
);

//create an instance of RAM
RAM_32x64k_avalon #(RAM_INIT_FILE) ramInst(
        .rst(rst),
        .clk(clk),
        .address(address), 
        .write(write), 
        .read(read), 
        .waitrequest(waitrequest), 
        .writedata(writedata), 
        .byteenable(byteenable), 
        .readdata(readdata)
);

//generating clock
initial begin
    clk=0;
    
    repeat (TIMEOUT_CYCLES) begin
        #10
        clk = !clk;
        #10
        clk = !clk;
    end
    $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
end

//reset 
initial begin
    //there maybe two ways of testing:
    //check the value stored in the register_v0, it can act like an accumulator, 
    //also, store the value calculated in the ram, and lw the same location, so v0 should contain the 
    // value we stored.
    //outpus the the values in register_v0:

    rst <= 0;

    @(posedge clk);
    rst <= 1;

    @(posedge clk);
    rest <= 0;

    // test whether the CPU has been correctly evoked after reset
    @(posedge clk);
    assert(active==1)
    else &display("TB: CPU did not set running=1 after reset.");

    while(active) begin
        &(posedge clk)
        &display("register_v0: %d",register_v0);
    end

    // finished the simulation
    
    $display("TB: finished; running=0");

    $finish;
end



endmodule 
`include "mips_cpu_bus.v"
`include "RAM_32x64k_avalon.v"


module mips_cpu_bus_tb();

    // parameter RAM_INIT_FILE = "../test/binary/cpu_integration.hex.txt";
    parameter RAM_INIT_FILE = "../test/binary/shifts.hex.txt";
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
    logic[31:0] simulated_address;

    assign simulated_address = address - 32'hBFC00000; 
    // map the real memory space(2^32) to simulated memory space(2^16)
    // the simulated memory space only contain [0x0000, 0xFFFF]
    // so it can only simulate a range of the real memory [0xBFC00000, 0xBFC0FFFF]

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
    RAM_32x64k_avalon #(RAM_INIT_FILE) ram(
        .rst(reset),
        .p(pending),
        .clk(clk),
        .address(simulated_address), 
        .write(write), 
        .read(read), 
        .waitrequest(waitrequest), 
        .writedata(writedata), 
        .byteenable(byteenable), 
        .readdata(readdata)
    );

    always @(posedge clk) begin
    // check the validity of memory address
        if (active) begin
            if (address == 32'h0) begin 
                $display("[TB] : LOG : 🚧 PC == 0x0, CPU should halt then");
            end
            else begin
                assert(address <= 32'hBFC0FFFF && address >= 32'hBFC00000) 
                begin
                    $display("[TB] : LOG : ✅ address %h is accessible", address);
                end
                else begin
                    $fatal(1, "[TB] : FATAL : ❌ the requested address %h, which mapped to %h, is out of range.", address, simulated_address);
                end
            end
        end
    end

    initial begin
    // Generate clock
        clk=0;
        $dumpfile("mips_cpu_bus_tb.vcd");
        $dumpvars(0, mips_cpu_bus_tb);

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end

    initial begin
        $display("Start integration test of cpu");
        reset <= 0;

        @(posedge clk);
        reset <= 1;

        @(posedge clk);
        reset <= 0;

        @(posedge clk);
        assert(active == 1); 
        else begin
            $error("[TB]: CPU did not assert `avtive` after reset.");
        end

        @(posedge clk);
        while(active) begin
            @(posedge clk);
        end

        $display("[TB] : LOG : 🥳 Finished, register_v0 = %h", register_v0);

        $finish;
    end

endmodule

module mips_cpu_bus_tb();

    parameter RAM_INSTR_INIT_FILE = "unit_test/instruction_hex/cpu_integration.hex.txt";
    parameter RAM_INSTR_SIZE= 10;
    parameter RAM_DATA_INIT_FILE = "unit_test/instruction_hex/cpu_integration.hex.txt";
    parameter RAM_DATA_SIZE= 10;

    parameter VCD_OUTPUT = "mips_cpu_bus_tb.vcd";
    parameter TIMEOUT_CYCLES = 1000;

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
    logic[31:0] inspected_address;

    logic dump;

    assign simulated_address = (dump ? inspected_address : address) - 32'hBFC00000; 
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
    RAM_32x64k_avalon #(
        .RAM_INSTR_INIT_FILE(RAM_INSTR_INIT_FILE), 
        .RAM_INSTR_SIZE(RAM_INSTR_SIZE), 
        .RAM_DATA_INIT_FILE(RAM_DATA_INIT_FILE), 
        .RAM_DATA_SIZE(RAM_DATA_SIZE)
    ) ram(
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

    always_ff @(negedge active) begin
        dump <= 1;
    end

    always @(posedge clk) begin
    // check the validity of memory address
        if (active) begin
            if (address == 32'h0) begin 
                $display("[TB] : LOG : 🚧 PC == 0x0, CPU should halt then");
            end
            else begin
                assert(address <= 32'hBFC0FFFF && address >= 32'hBFC00000) 
                begin
                    // $display("[TB] : LOG : ✅ address %h is accessible", address);
                end
                else begin
                    $fatal(1, "[TB] : FATAL : ❌ the requested address %h, which mapped to %h, is out of range.", address, simulated_address);
                end
            end
        end
    end

    always @(posedge clk) begin
        if (!waitrequest & active) begin
            if(read) begin
                $display("[TB] : MEM : read from memory[%h] %h", address, readdata);
            end
            if (write) begin
                $display("[TB] : MEM : write to  memory[%h] %h", address, writedata);
            end
        end
    end

    initial begin
    // Generate clock
        clk=0;
        $dumpfile(VCD_OUTPUT);
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
        dump <= 0;
        inspected_address <= 32'hBFC00400;
        $display("Start integration test of cpu");
        reset <= 0;

        @(posedge clk);
        reset <= 1;

        @(posedge clk);
        reset <= 0;

        @(posedge clk);
        assert(active == 1); 
        else begin
            $fatal(1, "[TB]: CPU did not assert `avtive` after reset.");
        end

        @(posedge clk);
        while(active) begin
            @(posedge clk);
        end

        $display("[TB] : LOG : 🥳 Finished, register_v0 = %h", register_v0);
        dump_mem();

        $finish;
    end

task dump_mem;
    logic [32:0] cnt;
    cnt <= 32'h0;

    $display("==== [Start] Content in the data section after execution ============");
    repeat(RAM_DATA_SIZE) begin
        @(posedge clk);
            inspected_address <= 32'hBFC00400 + cnt;
        @(negedge waitrequest) begin
            $display("DATA_MEM[%h] = %h", inspected_address, readdata);
        end
        cnt += 32'h4;
    end
    $display("==== [End]   Content in the data section after execution ============");
endtask

endmodule

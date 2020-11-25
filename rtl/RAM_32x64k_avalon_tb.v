`include "RAM_32x64k_avalon.v"

module RAM_32x64k_avalon_tb;
    // timeunit 1ns / 10ps;
    
    parameter RAM_INIT_FILE = "../test/binary/RAM_avalon.hex.txt";
    parameter TIMEOUT_CYCLES = 100;

    logic clk;
    logic rst;

    logic running;

    logic[31:0] address;
    logic write;
    logic read;
    logic waitrequest;
    logic[31:0] writedata;
    logic[31:0] readdata;
    logic[3:0] byteenable;
    logic pending;

    // logic[31:0] cnt;
    // wire[31:0] cnt_next;
    // assign cnt_next = cnt + 1; 

    // Instanciation of RAM_32x64k_avalon
    RAM_32x64k_avalon #(RAM_INIT_FILE) ramInst(
        .rst(rst),
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

    // Generate clock
    initial begin
        clk=0;
        $dumpfile("RAM_32x64k_avalon_tb.vcd");
        $dumpvars(0, RAM_32x64k_avalon_tb);

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end


    initial begin
        rst <= 0;
        // cnt <= 0;
        read <= 0;
        write <= 0;
        address <= 0;
        byteenable <= 4'b0000;
        #20

        @(posedge clk)
        rst <= 1;
        #60

        @(posedge clk)
        rst <= 0;

        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        //--------------------------------------------------------------------
        // Test(1): read from 0x0001 
        //--------------------------------------------------------------------

        @(posedge clk)
        address <= 1;
        read <= 1;
        write <= 0;
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        @(posedge clk)
        address <= 1;
        read <= 1;
        write <= 0;
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        @(negedge clk) // compare results
        assert(readdata == 32'h01000000);
        else begin 
            $fatal(1, "readdata not matched");
        end


        //--------------------------------------------------------------------
        // Test(2): read from 0x0002 
        //--------------------------------------------------------------------

        @(posedge clk)
        address <= 2;
        read <= 1;
        write <= 0;
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);


        //--------------------------------------------------------------------
        // Test(3): not maintain `address` when the previous read operation 
        //       have not finished 
        //--------------------------------------------------------------------

        @(posedge clk)
        address <= 0;
        read <= 1;
        write <= 0;

        @(negedge clk) // compare results for Test(2)
        assert(readdata == 32'h00100000);
        else begin 
            $fatal(1, "readdata not matched");
        end

        @(posedge clk)
        address <= 0;
        read <= 1;
        write <= 0;
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        #20

        @(negedge clk) // compare results
        assert(readdata == 32'h10000000);
        else begin 
            $fatal(1, "readdata not matched");
        end

        //--------------------------------------------------------------------
        // Test(4): write 0x12345678 to  RAM[0x0002] 
        //--------------------------------------------------------------------

        @(posedge clk)
        address <= 2;
        byteenable <= 4'b0011;
        read <= 0;
        write <= 1;
        writedata <= 32'h12345678;
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        @(posedge clk)
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        @(posedge clk) // Fetch RAM[0x0002]
        address <= 2;
        read <= 1;
        write <= 0;
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        @(posedge clk)
        address <= 2;
        read <= 1;
        write <= 0;
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);

        @(posedge clk) // compare result 
        $display("[TB] address: %h", address);
        $display("[TB] readdata: %h", readdata);
        assert(readdata == 32'h00005678); 
        else begin 
            $error("content write to RAM not correct");
            $finish(1);
        end

        #40


        // $display("⌛  CPU finished in %d cycles", cnt);
        // $display("TB : finished; running=0");

        $finish;
            
    end

endmodule

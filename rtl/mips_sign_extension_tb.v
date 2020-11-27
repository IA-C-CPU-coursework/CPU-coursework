`include "mips_sign_extension.v"

module mips_sign_extension_tb;

    parameter TIMEOUT_CYCLES = 100;

    logic clk;
    logic rst;

    logic[15:0] data_in;
    logic[31:0] data_out;

    // DUT Instanciation of mips_sign_extension
    mips_sign_extension signExt(
        .i(data_in),
        .o(data_out)
    );

    task test;
        input [15:0] data_in;
        logic [31:0] sign_extended;

        sign_extended <= 32'haabbccdd;

        @(posedge clk);
        sign_extended <= $signed(data_in);

        @(posedge clk);
        assert(data_out == sign_extended) begin
            $display("data_out == $signed(data_in) %h %h", data_out, sign_extended); 
        end
        else begin
            $error("data_out != $signed(data_in) %h %h", data_out, sign_extended); 
        end
    endtask


    initial begin
    // Generate clock
        clk=0;
        $dumpfile("mips_sign_extension_tb.vcd");
        $dumpvars(0, mips_sign_extension_tb);

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end


    initial begin
    // Test Cases
        
        //--------------------------------------------------------------------
        // Test 01 sign extension of 0
        // i.e. all zeros: 0000,0000,0000,0000
        //--------------------------------------------------------------------

        data_in <= 16'h0;
        #1 test(data_in);


        //--------------------------------------------------------------------
        // Test 02 sign extension of 0xffff
        // i.e. all ones: 1111,1111,1111,1111
        //--------------------------------------------------------------------


        data_in <= 16'hffff;
        #1 test(data_in);


        //--------------------------------------------------------------------
        // Test 03 sign extension of 0x7fff
        // i.e. all ones: 0111,1111,1111,1111
        //--------------------------------------------------------------------

        data_in <= 16'h7fff;
        #1 test(data_in);


        //--------------------------------------------------------------------
        // Test 04 sign extension of 0x8000
        // i.e. all ones: 1000,0000,0000,0000
        //--------------------------------------------------------------------

        data_in <= 16'h8000;
        #1 test(data_in);


        //--------------------------------------------------------------------
        // Test 05 sign extension of 0x0001
        // i.e. all ones: 0000,0000,0000,0001
        //--------------------------------------------------------------------

        data_in <= 16'h0001;
        #1 test(data_in);


        //--------------------------------------------------------------------
        // Test 05 sign extension of 0xfffe
        // i.e. all ones: 1111,1111,1111,1111
        //--------------------------------------------------------------------

        data_in <= 16'hfffe;
        #1 test(data_in);


        $finish;
            
    end

endmodule

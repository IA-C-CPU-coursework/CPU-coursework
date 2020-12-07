`include "../mips_cpu/mips_sign_extension.v"

module mips_sign_extension_tb;

    parameter TIMEOUT_CYCLES = 100;

    logic clk;
    logic rst;

    logic[15:0] offset;
    logic[31:0] signed_offset;

    // DUT Instantiation of mips_sign_extension
    mips_sign_extension signExt(
        .offset(offset),
        .signed_offset(signed_offset)
    );

    task test;
        input [15:0] offset;
        logic [31:0] sign_extended;

        sign_extended <= 32'haabbccdd;

        @(posedge clk);
        sign_extended <= $signed(offset);

        @(posedge clk);
        assert(signed_offset == sign_extended) begin
            $display("✅ signed_offset == $signed(offset) %h %h", signed_offset, sign_extended); 
        end
        else begin
            $error("❌ signed_offset != $signed(offset) %h %h", signed_offset, sign_extended); 
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
    $display("Start unit test for mips_sign_extension");
    // Test Cases
        
        //--------------------------------------------------------------------
        // Test 01 sign extension of 0
        // i.e. all zeros: 0000,0000,0000,0000
        //--------------------------------------------------------------------

        offset <= 16'h0;
        #1 test(offset);


        //--------------------------------------------------------------------
        // Test 02 sign extension of 0xffff
        // i.e. all ones: 1111,1111,1111,1111
        //--------------------------------------------------------------------


        offset <= 16'hffff;
        #1 test(offset);


        //--------------------------------------------------------------------
        // Test 03 sign extension of 0x7fff
        // i.e. all ones: 0111,1111,1111,1111
        //--------------------------------------------------------------------

        offset <= 16'h7fff;
        #1 test(offset);


        //--------------------------------------------------------------------
        // Test 04 sign extension of 0x8000
        // i.e. all ones: 1000,0000,0000,0000
        //--------------------------------------------------------------------

        offset <= 16'h8000;
        #1 test(offset);


        //--------------------------------------------------------------------
        // Test 05 sign extension of 0x0001
        // i.e. all ones: 0000,0000,0000,0001
        //--------------------------------------------------------------------

        offset <= 16'h0001;
        #1 test(offset);


        //--------------------------------------------------------------------
        // Test 05 sign extension of 0xfffe
        // i.e. all ones: 1111,1111,1111,1111
        //--------------------------------------------------------------------

        offset <= 16'hfffe;
        #1 test(offset);


        $finish;
            
    end

endmodule

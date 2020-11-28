`include "mips_reg_file.v"

module mips_reg_file_tb;
    // timeunit 1ns / 10ps;
    
    parameter TIMEOUT_CYCLES = 100;

    logic clk;
    logic rst;

    logic write;

    logic[4:0] write_address;
    logic[4:0] read_address_1;
    logic[4:0] read_address_2;
    logic[31:0] data_in;
    logic[31:0] data_out_1;
    logic[31:0] data_out_2;


    logic [4:0] cnt;
    logic [4:0] cnt_next;

    assign cnt_next = cnt + 1;

    // DUT instanciation of mips_reg_file
    mips_reg_file regFile(
        .rst(rst),
        .CLK(clk),
        .RegWrite(write),
        .WriteAddress(write_address),
        .Address1(read_address_1),
        .Address2(read_address_2),
        .DataIn(data_in),
        .DataOut1(data_out_1),
        .DataOut2(data_out_2)
    );

    initial begin
    // Generate clock
        clk=0;
        $dumpfile("mips_reg_file_tb.vcd");
        $dumpvars(0, mips_reg_file_tb);

        repeat (TIMEOUT_CYCLES) begin
            #10;
            clk = !clk;
            #10;
            clk = !clk;
        end

        $fatal(2, "Simulation did not finish within %d cycles.", TIMEOUT_CYCLES);
    end


    initial begin
        $display("Start unit test of mips_reg_file");
        reset();
        test_reset_to_zero();
        test_write_to_reg_zero();
        test_write();
        test_read_from_the_same_reg_at_the_same_time();
        test_read_from_two_regs_at_the_same_time();

        #100;
        $finish;
    end
        
    task reset;
    // reset registers
        rst <=1;
        write <= 0;
        write_address <= 0;
        data_in <= 0;
        cnt <= 0;

        @(posedge clk);
        rst <= 0;
    endtask


    task test_reset_to_zero;
    // test whether all registers are reset to zero
        logic correct;
        correct <= 1;

        repeat(16) begin
            @(posedge clk);
            read_address_1 <= 2*cnt;
            read_address_2 <= 2*cnt + 1;
            
            @(posedge clk);
            #20;
            assert(data_out_1 == 32'h0);
            else begin 
                $error("❌ reg[%d] is not initialised to 0, but %h", read_address_1, data_out_1);
                correct <= 0;
            end 
            assert(data_out_2 == 32'h0);
            else begin 
                $error("❌ reg[%d] is not initialised to 0, but %h", read_address_2, data_out_2);
                correct <= 0;
            end 

            @(posedge clk);
            cnt <= cnt_next;
        end

        if (correct) begin
            $display("✅ registers are all reseted to 0");
        end
        else begin
            $error("❌ registers are not all reseted to 0");
        end
        cnt <= 0;
    endtask

    task test_write;
        @(posedge clk);
        write <= 1;
        write_address <= 1;
        data_in <= 32'h00012345;

        @(posedge clk);
        write <= 0;
        read_address_1 <= 1;

        @(posedge clk);
        assert(data_out_1 == 32'h00012345) begin 
            $display("✅ reg[1] can be written correctly.");
        end
        else begin 
            $error("❌ reg[1] can not be written correctly, reg[1] = %h, expects 32'h00012345", data_out_1);
        end
    endtask

    task test_read_from_the_same_reg_at_the_same_time;
        @(posedge clk);
        write <= 1;
        write_address <= 2;
        data_in <= 32'h00123456;

        @(posedge clk);
        write <= 0;
        read_address_1 <= 2;
        read_address_2 <= 2;

        @(posedge clk);
        assert(data_out_1 == data_out_2 && data_out_1 == 32'h00123456) begin 
            $display("✅ reg[2] can be read correctly by data_out_1 and data_out_2 at the same time.");
        end
        else begin 
            $error("❌ reg[2] can not be written correctly by data_out_1 and data_out_2 at the same time. \n expected: 32'h123456, data_out_1 = %h data_out_2 = %h", data_out_1, data_out_2);
        end
    endtask

    task test_read_from_two_regs_at_the_same_time;
        @(posedge clk);
        write <= 1;
        write_address <= 3;
        data_in <= 32'h01234567;

        @(posedge clk);
        write <= 1;
        write_address <= 4;
        data_in <= 32'h12345678;

        @(posedge clk);
        write <= 0;
        read_address_1 <= 3;
        read_address_2 <= 4;

        @(posedge clk);
        assert(data_out_1 == 32'h01234567 && data_out_2 == 32'h12345678) begin 
            $display("✅ reg[3] and reg[4] can be read correctly by data_out_1 and data_out_2 at the same time.");
        end
        else begin 
            $error("❌ reg[3] and reg[4] can not be written correctly by data_out_1 and data_out_2 at the same time. \n expected: data_out_1 = 32'h1234567, data_out_2 = 32'h12345678, \n data_out_1 = %h data_out_2 = %h", data_out_1, data_out_2);
        end
    endtask

    task test_write_to_reg_zero;
    // test whether register $zero can be written
        @(posedge clk);
        write <= 1;
        write_address <= 0;
        data_in <= 32'h00012345;

        @(posedge clk);
        write <= 0;
        read_address_1 <= 0;

        @(posedge clk);
        assert(data_out_1 == 32'h0) begin 
            $display("✅ register zero cannot be changed.");
        end
        else begin 
            $error("❌ reg[%d] is changed to %h, expects 0", read_address_1, data_out_1);
        end 
    endtask


endmodule

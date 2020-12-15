`include "../mips_cpu/mips_reg_file.v"

module mips_reg_file_tb;
    // timeunit 1ns / 10ps;
    
    parameter TIMEOUT_CYCLES = 100;

    logic clk;
    logic rst;

    logic write;

    logic[4:0] write_addr;
    logic[4:0] read_addr_1;
    logic[4:0] read_addr_2;
    logic[31:0] write_data;
    logic[31:0] read_data_1;
    logic[31:0] read_data_2;


    logic [4:0] cnt;
    logic [4:0] cnt_next;

    assign cnt_next = cnt + 1;

    // DUT instantiation of mips_reg_file
    mips_reg_file regFile(
        .rst(rst),
        .clk(clk),
        .RegWrite(write),
        .write_addr(write_addr),
        .read_addr_1(read_addr_1),
        .read_addr_2(read_addr_2),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
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
        write_addr <= 0;
        write_data <= 0;
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
            read_addr_1 <= 2*cnt;
            read_addr_2 <= 2*cnt + 1;
            
            @(posedge clk);
            #20;
            assert(read_data_1 == 32'h0);
            else begin 
                $error("❌ reg[%d] is not initialised to 0, but %h", read_addr_1, read_data_1);
                correct <= 0;
            end 
            assert(read_data_2 == 32'h0);
            else begin 
                $error("❌ reg[%d] is not initialised to 0, but %h", read_addr_2, read_data_2);
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
        write_addr <= 1;
        write_data <= 32'h00012345;

        @(posedge clk);
        write <= 0;
        read_addr_1 <= 1;

        @(posedge clk);
        assert(read_data_1 == 32'h00012345) begin 
            $display("✅ reg[1] can be written correctly.");
        end
        else begin 
            $error("❌ reg[1] can not be written correctly, reg[1] = %h, expects 32'h00012345", read_data_1);
        end
    endtask

    task test_read_from_the_same_reg_at_the_same_time;
        @(posedge clk);
        write <= 1;
        write_addr <= 2;
        write_data <= 32'h00123456;

        @(posedge clk);
        write <= 0;
        read_addr_1 <= 2;
        read_addr_2 <= 2;

        @(posedge clk);
        assert(read_data_1 == read_data_2 && read_data_1 == 32'h00123456) begin 
            $display("✅ reg[2] can be read correctly by read_data_1 and read_data_2 at the same time.");
        end
        else begin 
            $error("❌ reg[2] can not be written correctly by read_data_1 and read_data_2 at the same time. \n expected: 32'h123456, read_data_1 = %h raed_data_2 = %h", read_data_1, read_data_2);
        end
    endtask

    task test_read_from_two_regs_at_the_same_time;
        @(posedge clk);
        write <= 1;
        write_addr <= 3;
        write_data <= 32'h01234567;

        @(posedge clk);
        write <= 1;
        write_addr <= 4;
        write_data <= 32'h12345678;

        @(posedge clk);
        write <= 0;
        read_addr_1 <= 3;
        read_addr_2 <= 4;

        @(posedge clk);
        assert(read_data_1 == 32'h01234567 && read_data_2 == 32'h12345678) begin 
            $display("✅ reg[3] and reg[4] can be read correctly by read_data_1 and read_data_2 at the same time.");
        end
        else begin 
            $error("❌ reg[3] and reg[4] can not be written correctly by read_data_1 and read_data_2 at the same time. \n expected: read_data_1 = 32'h1234567, read_data_2 = 32'h12345678, \n read_data_1 = %h read_data_2 = %h", read_data_1, read_data_2);
        end
    endtask

    task test_write_to_reg_zero;
    // test whether register $zero can be written
        @(posedge clk);
        write <= 1;
        write_addr <= 0;
        write_data<= 32'h00012345;

        @(posedge clk);
        write <= 0;
        read_addr_1 <= 0;

        @(posedge clk);
        assert(read_data_1 == 32'h0) begin 
            $display("✅ register zero cannot be changed.");
        end
        else begin 
            $error("❌ reg[%d] is changed to %h, expects 0", read_addr_1, read_data_1);
        end 
    endtask


endmodule

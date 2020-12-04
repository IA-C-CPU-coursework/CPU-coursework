`include "mips_state_machine.v"

module mips_state_machine_tb;

    parameter TIMEOUT_CYCLES = 100; // set maximum #cycle of execution 

    // signals required by mips_state_machines
    logic clk;
    logic rst;
    logic halt;
    logic extra;
    logic waitrequest;
    logic[1:0] state;

    logic correct;

    // DUT instantiation of mips_state_machine
    mips_state_machine stateMachine(
        .clk(clk),
        .rst(rst),
        .halt(halt),
        .extra(extra),
        .waitrequest(waitrequest),
        .s(state)
    );

    initial begin
    // Generate clock
        clk=0;
        $dumpfile("mips_state_machine_tb.vcd");
        $dumpvars(0, mips_state_machine_tb);

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
        halt <= 0;
        waitrequest <= 0;
        extra <= 0;
        correct <= 0;

        @(posedge clk);

        $display("Starts unit test for mips_state_machine");
        test_reset();
        test_two_cycle();
        test_three_cycle();
        test_waitrequest();
        test_halt();
        $finish(0);
    end

    task test_reset;
        @(posedge clk);
        correct <= 1;

        @(posedge clk);
        halt <= 0;
        rst <= 1;

        @(posedge clk);
        halt <= 0;
        rst <= 0;

            @(negedge clk);
            assert(state == 2'b00);
            else begin 
                $error("❌ state machine failed to reset to FETCH state, but %b", state);
                correct <= 0;
            end

        @(posedge clk);

        @(posedge clk);
        if(correct) begin 
            $display("✅ passed test_reset");
        end 
        else begin 
            $display("❌ failed test_reset");
        end
    endtask


    task test_halt;
        @(posedge clk);
        correct <= 1;

        @(posedge clk);
        halt <= 0;
        rst <= 0;

            @(negedge clk);
            assert(state != 2'b11);
            else begin 
                $error("❌ state machine enters HALT unexpectedly, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        halt <= 1;
        rst <= 0;

        @(posedge clk);

            @(negedge clk);
            assert(state == 2'b11);
            else begin 
                $error("❌ state machine failed to enter HALT state when halts, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        halt <= 0;
        rst <= 0;

            @(negedge clk);
            assert(state == 2'b11);
            else begin 
                $error("❌ state machine failed to remain HALT state, %b", state);
            end

        @(posedge clk);
        halt <= 1;
        rst <= 1;

        @(posedge clk);

            @(negedge clk);
            assert(state == 2'b11);
            else begin 
                $error("❌ state machine failed to enter/remain HALT state when both `rst` and `halt` asserted, %b", state);
            end

        @(posedge clk);

        @(posedge clk);
        if(correct) begin 
            $display("✅ passed test_halt");
        end 
        else begin 
            $display("❌ failed test_halt");
        end
    endtask


    task test_two_cycle;
        @(posedge clk);
        correct <= 1;

        @(posedge clk);
        rst <= 1;
        halt <= 0;
        waitrequest <= 0;
        extra <= 0;

        @(posedge clk);
        rst <= 0;

        @(posedge clk);
        rst <= 0;

            @(negedge clk);
            assert(state == 2'b01);
            else begin 
                $error("❌ state machine failed to enter EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        rst <= 0;

            @(negedge clk);
            assert(state == 2'b00);
            else begin 
                $error("❌ state machine failed to return to FETCH from EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);

        @(posedge clk);
        if(correct) begin 
            $display("✅ passed test_two_cycle");
        end 
        else begin 
            $display("❌ failed test_two_cycle");
        end
    endtask


    task test_three_cycle;
        @(posedge clk);
        correct <= 1;

        @(posedge clk);
        // reset 
        rst <= 1;
        halt <= 0;
        waitrequest <= 0;
        extra <= 0;

        @(posedge clk);
        // state == FETCH
        rst <= 0;

        @(posedge clk);
        // state == EXEC1
        rst <= 0;
        extra <= 1;

            @(negedge clk);
            assert(state == 2'b01);
            else begin 
                $error("❌ state machine failed to enter EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        // state == EXEC2
        rst <= 0;
        extra <= 0;

            @(negedge clk);
            assert(state == 2'b10);
            else begin 
                $error("❌ state machine failed to enter EXEC2 from EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        // state == FETCH
        rst <= 0;

            @(negedge clk);
            assert(state == 2'b00);
            else begin 
                $error("❌ state machine failed to return to FETCH from EXEC2, %b", state);
                correct <= 0;
            end

        @(posedge clk);

        @(posedge clk);
        if(correct) begin 
            $display("✅ passed test_three_cycle");
        end 
        else begin 
            $display("❌ failed test_three_cycle");
        end
    endtask


    task test_waitrequest;
        @(posedge clk);
        correct <= 1;

        @(posedge clk);
        // reset 
        rst <= 1;
        halt <= 0;
        waitrequest <= 0;
        extra <= 0;

        @(posedge clk);
        // state == FETCH
        rst <= 0;

        @(posedge clk);
        // state == EXEC1
        rst <= 0;
        extra <= 1;
        waitrequest <= 1;

            @(negedge clk);
            assert(state == 2'b01);
            else begin 
                $error("❌ state machine failed to enter EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk)
        // stall cycle #1

            @(negedge clk);
            assert(state == 2'b01);
            else begin 
                $error("❌ state machine failed to enter EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk)
        // stall cycle #2
        waitrequest <= 0;

            @(negedge clk);
            assert(state == 2'b01);
            else begin 
                $error("❌ state machine failed to enter EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        // state == EXEC2
        rst <= 0;
        extra <= 0;
        waitrequest <= 1;

            @(negedge clk);
            assert(state == 2'b10);
            else begin 
                $error("❌ state machine failed to enter EXEC2 from EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        // stall cycle #1

            @(negedge clk);
            assert(state == 2'b10);
            else begin 
                $error("❌ state machine failed to enter EXEC2 from EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        // stall cycle #2

            @(negedge clk);
            assert(state == 2'b10);
            else begin 
                $error("❌ state machine failed to enter EXEC2 from EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        // stall cycle #3
        waitrequest <= 0;

            @(negedge clk);
            assert(state == 2'b10);
            else begin 
                $error("❌ state machine failed to enter EXEC2 from EXEC1, %b", state);
                correct <= 0;
            end

        @(posedge clk);
        // state == FETCH
        rst <= 0;

            @(negedge clk);
            assert(state == 2'b00);
            else begin 
                $error("❌ state machine failed to return to FETCH from EXEC2, %b", state);
                correct <= 0;
            end

        @(posedge clk);

        @(posedge clk);
        if(correct) begin 
            $display("✅ passed test_waitrequest");
        end 
        else begin 
            $display("❌ failed test_waitrequest");
        end
    endtask

endmodule

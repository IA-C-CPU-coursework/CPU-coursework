//-----------------------------------------------------------------------------
// State Machine Module 
// 
// set state to FETCH when `rst` is asserted
// set state to HALT when `halt` is asserted 
// keep state unchanged when `waitrequest` is asserted 
// switch to EXEC2 state if `extra` is asserted
//-----------------------------------------------------------------------------

typedef enum logic[1:0] {
    FETCH = 2'b00,
    EXEC1 = 2'b01,
    EXEC2 = 2'b10,
    HALT  = 2'b11
} state_t;

module mips_state_machine(
    input clk,
    input rst,
    input halt,
    input extra,
    input waitrequest,
    output [1:0] s
);

    state_t state;
    assign s = state;

    initial begin 
    // initialise state to HALT
        state <= HALT;
    end

    always_ff @(posedge clk) begin 
        if(halt) begin
        // set state to HALT when `halt` is asserted  
            state <= HALT;
        end
        else if(rst & !halt) begin
        // reset state to FECTH only when `rst` is asserted and `halt` is disasserted 
            state <= FETCH;
        end 
        else begin
            if (waitrequest) begin 
            // do nothing when `waitrequest` is asserted, just wait for the Avalon-slave to finish operation
            end
            else begin 
            // `waitrequest`, `halt` and `rst` are all disasserted
                case(state) 
                    FETCH: state <= EXEC1;
                    EXEC1: state <= extra ? EXEC2 : FETCH; // move from EXEC1 to EXEC2 when extra is asserted 
                                                           // otherwise FETCH
                    EXEC2: state <= FETCH;
                    HALT:  state <= HALT;
                    default: state <= 2'bxx;
                endcase 
            end
        end
    end

endmodule

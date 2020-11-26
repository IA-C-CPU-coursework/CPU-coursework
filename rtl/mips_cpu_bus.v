module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
    );
    

    wire [5:0] opcode = address[31:26];
    wire [25:0] jump_address = readdata[25:0];
    logic resetlastclock = 0;

    typedef enum logic[2:0] {
        FETCH_INSTR_ADDR = 3'b000,
        FETCH_INSTR_DATA = 3'b001,
        EXEC_INSTR_ADDR  = 3'b010,
        EXEC_INSTR_DATA  = 3'b011,
        HALTED =      3'b100
    } state_t;

    state_t state;

    always @(posedge clk) begin
        if(reset) begin
            if(resetlastclock) begin
                //RESET
                $display("CPU : Resetting.");
                pc <= 0;
                acc <= 0;
            end
            else begin
                resetlastclock <= 1;
            end
        end

        else begin
            resetlastclock <= 0;

            case(state)
            FETCH_INSTR_ADDR: begin
                
            end
            FETCH_INSTR_DATA: begin
                
            end
            EXEC_INSTR_ADDR: begin
                
            end
            EXEC_INSTR_DATA: begin
                
            end
            HALTED: begin
            end

            default: begin
                $fatal("Unexpected state: %d", state)
            end
            endcase
        end





    end 

    always_comb begin
        
    end
    
    always_ff (@posedge clk) begin
        
    end

endmodule
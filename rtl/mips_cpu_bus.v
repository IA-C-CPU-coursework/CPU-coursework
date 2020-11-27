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
    
    logic [7:0] pc = 0;
    wire pc_next = pc+1;
    wire [25:0] jump_address;
    wire instantALUinput[15:0];
    
    logic resetlastclock = 0;

    typedef enum logic[2:0] {
        FETCH_INSTR_ADDR = 3'b000,
        FETCH_INSTR_DATA = 3'b001,
        EXEC_INSTR_ADDR  = 3'b010,
        EXEC_INSTR_DATA  = 3'b011,
        HALTED =      3'b100,
        WAITING = 3'b101
    } state_t;

    state_t state;
    
    mips_reg_file(.rst(resetheld),.clk(clk),.WriteAddress(),.RegWrite(),.DataIn(),.Address1(),.Address2(),.DataOut1(),.DataOut2())
    
    logic resetheld = 0;
    always @(posedge clk) begin
        if(reset) begin
            if(resetlastclock) begin
                //RESET THE REGISTERS 
                resetheld = 1;
                $display("CPU : Resetting.");
                resetheld = 0;
                pc <= 32'hBFC00000; //Reset vector 
            end
            else begin
                resetlastclock <= 1;
            end
        end

        else begin
            resetlastclock <= 0;

            case(state)
                FETCH_INSTR_ADDR: begin
                    pc <= pc_next
                end
                FETCH_INSTR_DATA: begin
                    pc <= pc_next
                end
                EXEC_INSTR_ADDR: begin
                    pc <= pc_next
                end
                EXEC_INSTR_DATA: begin
                    pc <= pc_next
                end
                WAITING: begin
                    
                end
                HALTED: begin
                end

                default: begin
                    $fatal("CPU: Current State: %d",state)
                end
            endcase
        end





    end 

    always_comb begin
        
    end


endmodule

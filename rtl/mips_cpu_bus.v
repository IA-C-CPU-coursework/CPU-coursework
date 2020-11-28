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

    wire [5:0] opcode =  instruction [31:26];
    wire [5:0] FuncCode = instruction [5:0];
    logic [7:0] pc = 0;
 
    assign address = pc;
    wire pc_next;
    logic [25:0] jump_address;
    assign jump_address = instruction[25:0];
    wire [15:0] instant;
    
    logic resetlastedge = 0;
    logic [31:0] instruction;
    logic [31:0] data;

    typedef enum logic[2:0] {
        FETCH_INSTR_ADDR = 3'b000,
        FETCH_INSTR_DATA = 3'b001,
        EXEC_INSTR_ADDR  = 3'b010,
        EXEC_INSTR_DATA  = 3'b011,
        WRITE_BACK = 3'b100,
        HALTED =      3'b101

    } state_t;

    state_t state;
    wire [31:0] A,B;
    wire [4:0] rd,rs,rt;
    wire RegDst;
    assign rd = [20:16] instruction;
    assign rs = [25:21] instruction;
    assign rt = [16:11] instruction;
    wire [2:0] ALUControl;
    wire [4:0] Address2;
    wire MemRead,MemWrite,MemtoReg;
    wire RegWrite;
    wire ALUSrc;
    assign WriteAddress = RegDst ? rd:rt;
    assign read = MemRead;
    assign write = MemWrite;
    wire [31:0] ALUout;
    logic resetheld = 0;
    wire [31:0] writedata = MemtoReg ? ALUout:data
    wire [31:0] instantextended;
    wire [31:0] D2;
    assign B = ALUSrc ? D2:instantextended;
    wire jump, branch;

    mips_sign_extension(
        .i(instant),
        .o(instantextended)
    )

    mips_control_unit(
    .RegWrite(RegWrite)
    .opcode(opcode),
    .FuncCode(FuncCode),
    .reset(resetheld),
    .RegDst(RegDst),
    .ALUControl(ALUControl),
    .MemRead(MemRead),
    .MemWrite(MemWrite)
    .MemtoReg(MemtoReg)
    .ALUSrc(ALUSrc),
    .jump(jump),
    .branch(branch))

    mips_reg_file(
    .rst(resetheld),
    .clk(clk),
    .WriteAddress(WriteAddress),
    .RegWrite(RegWrite),
    .DataIn(writedata),
    .Address1(rs),
    .Address2(rt),
    .DataOut1(A),
    .DataOut2(D2))
   
    mips_alu(
    .ALUcontrol(ALUcontrol),
    .A(A),
    .B(B),
    .ALUout(ALUout),
    .Zero())

    always_comb begin
        if (pc==0) begin state = HALTED end
        
    end

    always_comb begin // determine next pc
        pc_next = jump ? (branch ? pc+4:( (pc +4) + (instantextended<<2) ) ):jump_address<<2
    end

    always @(posedge clk) begin
        if(reset) begin
            if(resetlastedge) begin
                //RESET THE REGISTERS 
                $display("CPU : Resetting.");

                pc <= 32'hBFC00000; //Reset vector 
                state <= FETCH_INSTR_ADDR;
            end
            else begin
                resetlastedge <= 1;
            end
        end

        else begin
            resetlastedge <= 0;

            case(state)
                FETCH_INSTR_ADDR: begin // GETS INSTRUCTION FROM RAM
                    
                    $display("CPU: Fetching address: %d",pc)
                    if(waitrequest)begin
                        
                    end
                    else begin
                        instruction <= readdata;
                        state <= EXEC_INSTR_ADDR;
                    end
                end
                FETCH_INSTR_DATA: begin //GETS REQUIRED REGISTER VALUES
                    $display("CPU: Fetching data from registers.")
                    
                end
                    
                end
                EXEC_INSTR_DATA: begin // MEMORY ACCESS
                    if(waitrequest) begin
                        $display("RAM: Readdata blocked by waitrequest")
                    end
                    else begin
                        data <= readdata;
                        $display("CPU: Read data from registers")
                    end
                    
                end
                WRITE_BACK: begin // WRITES TO REGISTERS
                    pc <= pc_next;
                    state <= FETCH_INSTR_ADDR;
                end
                HALTED: begin
                    $display("CPU: HALTED")
                end

                default: begin
                    $fatal("CPU: Current State: %d",state)
                end
            endcase
        end





    end 


endmodule

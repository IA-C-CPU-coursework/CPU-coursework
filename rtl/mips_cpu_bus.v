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
 
    wire [7:0] pc4 = pc+4;
    wire pc_next;

    
    wire [15:0] instant;
    
    logic resetlastedge = 0;
    logic [31:0] instruction;
    logic [31:0] data;

    typedef enum logic[3:0] {
        FETCH_INSTR_ADDR  = 4'b0000,
        FETCH_INSTR_DATA  = 4'b0001,
        EXEC_INSTR_ADDR   = 4'b0010,
        EXEC_INSTR_DATA   = 4'b0011,
        WRITE_BACK        = 4'b0100,
        HALTED            = 4'b0101,
        FETCH_BRANCH_ADDRESS = 4'b0110
        //FETCH_INSTR_ADDR = 4'b0110, //State' indicated a slot instruction
        //FETCH_INSTR_DATA = 4'b0111,
        //EXEC_INSTR_ADDR  = 4'b1000,
        //WRITE_BACK       = 4'b1001

    } state_t;

    state_t state;
    logic [25:0] jumptarget;
    wire [31:0] A,B;
    wire [4:0] rd,rs,rt;
    wire RegDst;
    assign rd =  instruction [20:16];
    assign rs =  instruction[25:21];
    assign rt =  instruction[16:11];
    wire [2:0] ALUControl;
    wire [3:0] byteenable_wire;
    wire [4:0] Address2;
    wire MemRead,MemWrite,MemtoReg;
    wire [4:0] WriteAddress;
    wire RegWrite;
    wire ALUSrc;
    assign WriteAddress = RegDst ? rd:rt;
    assign byteenable = byteenable_wire;
    wire [31:0] ALUout;
    logic resetheld = 0;
    assign writedata = MemtoReg ? data:ALUout;
    wire [31:0] instantextended;
    wire [31:0] D2;
    assign B = ALUSrc ? instantextended:D2;
    wire jumpimmediate,jumpfromreg, branch, link;
    wire branchtype = jumpimmediate || jumpfromreg || branch;
    wire jump = jumpimmediate || jumpfromreg;
    logic readinstruction;
    wire zero;

    mips_sign_extension sign_extender(
        .i(instant),
        .o(instantextended)
    );

    mips_control_unit control_unit(
    .RegWrite(RegWrite),
    .opcode(opcode),
    .FuncCode(FuncCode),
    .reset(resetheld),
    .RegDst(RegDst),
    .ALUControl(ALUControl),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ALUSrc(ALUSrc),
    .jumpimmediate(jumpimmediate),
    .jumpfromreg(jumpfromreg),
    .branch(branch),
    .link(link));

    mips_reg_file regfile(
    .rst(resetheld),
    .clk(clk),
    .WriteAddress(WriteAddress),
    .RegWrite(RegWrite),
    .DataIn(writedata),
    .Address1(rs),
    .Address2(rt),
    .DataOut1(A),
    .DataOut2(D2));
   
    mips_alu alu(
    .ALUcontrol(ALUControl),
    .A(A),
    .B(B),
    .ALUout(ALUout),
    .Zero(zero));

    always_comb begin
        if (pc==0) state = HALTED;
    end

    assign read = (state==FETCH_INSTR_ADDR) ? 1 : (state==EXEC_INSTR_ADDR && MemRead);
    
    assign write = state==EXEC_INSTR_DATA ? MemWrite : 0;

    assign address  = (state == FETCH_INSTR_ADDR) ? pc:ALUout;
    

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
                    
                    $display("CPU: Fetching address: %d",pc);
                    state <= FETCH_INSTR_ADDR;
                   
                end
                FETCH_INSTR_DATA: begin //GETS REQUIRED REGISTER VALUES
                    $display("CPU: Fetching data from registers.");
                    if(waitrequest)begin
                        
                    end
                    else begin
                        instruction <= readdata;
                        state <= EXEC_INSTR_ADDR;
                    end
                    if(branchtype) begin
                        state <= FETCH_BRANCH_ADDRESS;
                        
                    end
                    
                end
                EXEC_INSTR_ADDR:begin
                    
                end

                
                EXEC_INSTR_DATA: begin // MEMORY ACCESS
                    if(waitrequest) begin
                        $display("RAM: Readdata blocked by waitrequest");
                    end
                    else begin
                        data <= readdata;
                        $display("CPU: Read data from registers");
                    end
                    
                end
                WRITE_BACK: begin // WRITES TO REGISTERS
                    pc <= pc4;
                    state <= FETCH_INSTR_ADDR;
                end
                HALTED: begin
                    $display("CPU: HALTED");
                end

                FETCH_BRANCH_ADDRESS: begin
                    if (jump) begin 
                        jumptarget <= jumpfromreg ? A: instruction[25:0]; //Chooses immediate jump address or from register
                    end
                    
                end



                default: begin
                    $fatal("CPU: Current State: %d",state);
                end
            endcase
        end





    end 


endmodule

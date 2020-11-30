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
    logic [31:0] pc;
    logic resetted = 0;
    wire [31:0] v0;
    assign register_v0 = resetted?(active? 0:v0):0;
    initial begin
        active = 0;
        pc = 0;
    end
 
    wire [31:0] pc4 = pc+4;
    wire pc_next;     
    wire [15:0] instant;
    
    logic resetlastedge = 0;
    logic [31:0] instruction;
    logic [31:0] data;

    typedef enum logic[1:0] {
        FETCH_INSTR  = 2'b00,
        EXEC         = 2'b01,
        WRITE_BACK   = 2'b10,
        HALTED       = 2'b11
    } state_t;

    state_t state;

    logic [31:0] jumptarget;

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
    wire [31:0] wd;
    assign wd = MemtoReg ? data:ALUout;
    wire [31:0] instantextended;
    wire [31:0] D2;
    assign B = ALUSrc ? instantextended:D2;
    wire jumpimmediate, jumpfromreg, branch, link;
    wire branchtype = jump || branch;
    wire jump = jumpimmediate || jumpfromreg;
    logic readinstruction;
    wire zero;
    assign writedata = D2; 

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
    .DataIn(wd),
    .Address1(rs),
    .Address2(rt),
    .DataOut1(A),
    .DataOut2(D2),
    .regv0(v0)
    );
   
    mips_alu alu(
    .ALUcontrol(ALUControl),
    .A(A),
    .B(B),
    .ALUout(ALUout),
    .Zero(zero));

    always_comb begin
        if (pc==0) state = HALTED;
    end

    always @(*) begin // Gets jump address
        if(branch) begin
            jumptarget = pc+4+ instantextended;
            
        end
        else if (jump)begin
            if(jumpimmediate)begin
                jumptarget = {pc4[31:28],instruction[25:0],2'b00}; //cannot use always_comb because unsupported with constant
            end
            else if(jumpfromreg)begin
                jumptarget = A;
            end
        end
        
    end

    logic isDelaySlot = 0;
    logic faileddelay = 0;

    assign read = (state==FETCH_INSTR) ? 1 : (state==EXEC && MemRead);
    
    assign write = state==EXEC ? MemWrite : 0;

    assign address  = (state == FETCH_INSTR) ? pc:ALUout;
    

    always @(posedge clk) begin
        if(reset) begin
            active = 1;
            resetted = 1;
            if(resetlastedge) begin
                //RESET THE REGISTERS 
                $display("CPU : Resetting.");
                resetheld = 1;
                pc <= 32'hBFC00000; //Reset vector 
                state <= FETCH_INSTR;
            end
            else begin
                resetheld = 0;
                resetlastedge <= 1;
            end
        end

        else begin
            resetlastedge <= 0;

            case(state)

                /* During FETCH_INST the instruction is fetched, 
                the control signals are determined (comb),
                and the data is fetched from registers (comb)  */
                FETCH_INSTR: begin 
                    $display("CPU : INFO : Fetching data from registers.");
                    if(waitrequest)begin
                        $display("CPU : INFO : Received waitrequest while fetching instr");
                    end
                    else begin
                        instruction <= readdata;
                        if (MemRead || MemWrite)begin
                            state <= EXEC;
                        end
                        else begin
                            state <= WRITE_BACK;
                        end
                    end
                end

                /* During EXEC we handle the reading and writing of data to RAM.
                For convenience I have made 2 cycle instructions take 3 cycles. 
                */
                EXEC:begin
                    if(branchtype && !faileddelay) begin
                        /* Here we implement a delay slot*/
                        isDelaySlot <=1;
                        pc <= pc4;
                        state <= FETCH_INSTR;
                    end
                    if(isDelaySlot)begin
                        /*Here we make sure there is no branch in delay slot and return back to prev instr if there is*/
                        if(branchtype)begin
                            $display("CPU : INFO : Attemped to branch in delay slot. Going back to previous branch.");
                            pc <= pc - 4;
                            state <= FETCH_INSTR;
                            faileddelay <= 1;
                            isDelaySlot <=0;
                        end
                    end

                    if(waitrequest) begin
                        $display("CPU : INFO : Received waitrequest while fetching data");
                    end
                    else begin
                        data <= readdata;
                        state <= WRITE_BACK;
                    end
                end

                WRITE_BACK: begin 
                    pc <= branchtype ? jumptarget:pc4;                    
                    state <= FETCH_INSTR;
                    isDelaySlot <= 0;
                end

                HALTED: begin
                    $display("CPU: WARNING : HALTED");
                    active = 0;
                end

                default: begin
                    $fatal("CPU : FATAL : Unspecified state: %d",state);
                end
            endcase
        end
    end 

endmodule

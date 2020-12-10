//-----------------------------------------------------------------------------
//  Decoder Module 
//-----------------------------------------------------------------------------

module mips_decoder(
    input [31:0] instruction, // instruction read from memory
    input [31:0] pc, // instruction location
    input waitrequest, // indicate whether the memory is busy
    output Halt, // asserted when trying to execute instruction from 0x0
    input branch,
    // state machine 
    input [1:0] state, 
    output logic Extra,
    // momery
    output logic MemWrite,
    output logic MemRead,
    output logic [3:0] ByteEn,
    // register file 
    output logic RegWrite,
    output logic [1:0] RegData,
    // multiplexer 
    output logic MemSrc,
    output logic RegSrc,
    output logic ALUSrc1,
    output logic ALUSrc2,
    // program counter
    output logic [1:0] PCControl,
    output logic CntEn,
    // alu
    output logic [4:0] ALUControl,
    output logic is_branch
);

    assign Halt = pc == 0;
    // halt when program counter output 0x0
    // should not halt when read from 0x0


    //-------------------------------------------------------------------------
    // Segments of instruction and their functionalities
    //-------------------------------------------------------------------------

    logic [5:0] opcode;
        assign opcode = instruction[31:26]; // opcode is the first 6 significant bits
    logic [4:0] rs;
        assign rs = instruction[25:21]; // reg_src_1 
    logic [4:0] rt;
        assign rt = instruction[20:16]; // reg_src_2
    logic [4:0] rd;
        assign rd = instruction[15:11]; // write_addr also used to specify functions within the primary opcode value REGIMM
    logic [4:0] sa;
        assign sa = instruction[10:06]; // shift_amount
    logic [5:0] fncode;
        assign fncode = instruction[05:00]; // fncode is the least 6 significant bits
    logic [15:0] offset;
        assign offset = instruction[15:00]; 
    // 16-bit signed immediate used for: 
    //     logical operands, 
    //     arithmetic signed operands, 
    //     load/store address byte offsets, 
    //     PC-relative branch signed instruction displacement
    logic [25:0] instr_index;
        assign instr_index = instruction[25:0]; // 26-bit index shifted left two bits to supply the low-order 28 bits of the jump target address


    //-------------------------------------------------------------------------
    // Decode Instructions
    // 
    // Three types 
    // 1. completely determined by `opcode`
    // 2. SPECIAL `opcode`, need `fncode`
    // 3. REGIMM `opcode`, need `rt`
    //-------------------------------------------------------------------------

    logic SPECIAL;
        assign SPECIAL = opcode == 6'b000000;
    logic REGIMM;
        assign REGIMM  = opcode == 6'b000001;
    
    // arithmetic and logic
    logic ADDIU;
        assign ADDIU = opcode == 6'b001001;
    logic ADDU;
        assign ADDU = SPECIAL && fncode == 6'b100001;
    logic AND;
        assign AND = SPECIAL && fncode == 6'b100100;
    logic ANDI;
        assign ANDI = opcode == 6'b001100;
    logic LUI;
        assign LUI = opcode == 6'b001111;
    logic OR;
        assign OR = SPECIAL && fncode == 6'b100101;
    logic ORI;
        assign ORI = opcode == 6'b001101;
    logic SLT;
        assign SLT = SPECIAL && fncode == 6'b101010;
    logic SLTI;
        assign SLTI = opcode == 6'b001010;
    logic SLTIU;
        assign SLTIU = opcode == 6'b001011;
    logic SLTU;
        assign SLTU = SPECIAL && fncode == 6'b101011;
    logic SUBU;
        assign SUBU = SPECIAL && fncode == 6'b100011;
    logic XOR;
        assign XOR = SPECIAL && fncode == 6'b100110;
    logic XORI;
        assign XORI = opcode == 6'b001110;

    // shift 
    logic SLL;
        assign SLL = SPECIAL && fncode == 6'b000000;
    logic SLLV;
        assign SLLV= SPECIAL && fncode == 6'b000100;
    logic SRA;
        assign SRA = SPECIAL && fncode == 6'b000011;
    logic SRAV;
        assign SRAV = SPECIAL && fncode == 6'b000111;
    logic SRL;
        assign SRL = SPECIAL && fncode == 6'b000010;
    logic SRLV;
        assign SRLV = SPECIAL && fncode == 6'b000110;

    // multiply
    logic DIV;
        assign DIV = SPECIAL && fncode == 6'b011010;
    logic DIVU;
        assign DIVU = SPECIAL && fncode == 6'b011011;
    logic MFHI;
        assign MFHI = SPECIAL && fncode == 6'b010000;
    logic MFLO;
        assign MFLO = SPECIAL && fncode == 6'b010010;
    logic MTHI;
        assign MTHI = SPECIAL && fncode == 6'b010001;
    logic MTLO;
        assign MTLO = SPECIAL && fncode == 6'b010011;
    logic MULT;
        assign MULT = SPECIAL && fncode == 6'b011000;
    logic MULTU;
        assign MULTU = SPECIAL && fncode == 6'b011001;

    // branch
    logic BEQ;
        assign BEQ = opcode == 6'b000100;
    logic BGEZ;
        assign BGEZ = REGIMM && rt == 5'b00001;
    logic BGEZAL;
        assign BGEZAL = REGIMM && rt == 5'b10001;
    logic BGTZ;
        assign BGTZ = opcode == 6'b000111;
    logic BLEZ;
        assign BLEZ = opcode == 6'b000110;
    logic BLTZ;
        assign BLTZ = REGIMM && rt == 5'b00000;
    logic BLTZAL;
        assign BLTZAL = REGIMM && rt == 5'b10000;
    logic BNE;
        assign BNE = opcode == 6'b000101;
    logic J;
        assign J = opcode == 6'b000010;
    logic JAL;
        assign JAL = opcode == 6'b000011;
    logic JALR;
        assign JALR = SPECIAL && fncode == 6'b001001;
    logic JR;
        assign JR = SPECIAL && fncode == 6'b001000;

    // memory access
    logic LB;
        assign LB = opcode == 6'b100000;
    logic LBU;
        assign LBU = opcode == 6'b100100;
    logic LH;
        assign LH = opcode == 6'b100001;
    logic LHU;
        assign LHU = opcode == 6'b100101;
    logic LW;
        assign LW = opcode == 6'b100011;
    logic LWL;
        assign LWL = opcode == 6'b100010;
    logic LWR;
        assign LWR = opcode == 6'b100110;
    logic SB;
        assign SB = opcode == 6'b101000;
    logic SH;
        assign SH = opcode == 6'b101001;
    logic SW;
        assign SW = opcode == 6'b101011;

    // classification of instruction 
    logic load_instr; // load from memory to register, LUI is excluded 
        assign load_instr = LB || LBU || LH || LHU || LW || LWL || LWR;
    logic store_instr;
        assign store_instr = SB || SH || SW;
    logic jump_instr;
        assign jump_instr = J || JR || JAL || JALR; 
    logic branch_instr;
        assign branch_instr = BEQ || BGEZ || BGEZAL || BLTZ || BLTZAL || BLEZ || BGTZ || BNE;
    logic shift_instr;
        assign shift_instr = SLL || SLLV || SRA || SRAV || SRL || SRLV;
    logic three_cycle_instr;
        assign three_cycle_instr = load_instr;
    logic two_cycle_instr;
        assign two_cycle_instr = !three_cycle_instr;


    //-------------------------------------------------------------------------
    // Coordinate control signals based on instruction and state
    //-------------------------------------------------------------------------
    always_comb begin
        case(state)
            2'b00: begin 
            // state == FETCH 
                MemSrc      = 1'b1;
                MemWrite    = 1'b0;
                MemRead     = 1'b1;
                ByteEn      = 4'b1111;
                RegSrc      = 1'bx;
                RegData     = 2'bxx;
                RegWrite    = 1'b0;
                PCControl   = 2'bxx;
                CntEn       = 1'b0;
                ALUSrc1     = 2'bx;
                ALUSrc2     = 2'bx;
                ALUControl  = 5'bxxxxx;
            end
            2'b01: begin 
            // state == EXEC1
                MemSrc        = !store_instr && !load_instr || load_instr && !waitrequest;
                MemWrite      = store_instr;
                MemRead       = load_instr;
                ByteEn        = 4'b1111;
                RegSrc        = ADDIU || LUI || ORI || ANDI || XORI || SLTI || SLTIU;
                RegData       = 2'b10;
                RegWrite      = ADDIU || ADDU || LUI  || shift_instr || SUBU || OR || XOR || AND || ORI || ANDI || XORI || SLT || SLTI || SLTU || SLTIU;
                PCControl[1]  = !branch_instr;
                PCControl[0]  = !branch_instr && !(JR || JALR);
                CntEn         = !waitrequest && two_cycle_instr;
                ALUSrc1       = SLL   || SRA  || SRL;
                ALUSrc2       = ADDIU || LUI  || LW   || SW || ORI || ANDI ||XORI || SLTI || SLTIU;
                ALUControl[4] = LUI || ANDI || ORI || XORI || SLT || SLTI || SLTU || SLTIU;
                ALUControl[3] = shift_instr || SUBU || OR || XOR || SLT || SLTI || SLTU || SLTIU;
                ALUControl[2] = LUI   || SRA  || SRAV || SRL  || SRLV || SUBU || XOR || ANDI || ORI || XORI;
                ALUControl[1] = SLL   || SLLV || SUBU || OR || XOR || ORI || XORI;
                ALUControl[0] = SLL   || SLLV || SRL  || SRLV || AND || XOR || ANDI || XORI || SLTU || SLTIU;
                Extra         = three_cycle_instr;
                is_branch     = J || JAL || JR || JALR || BEQ || BGEZ || BGEZAL || BGTZ || BLEZ || BLTZ || BLTZAL || BNE;
            end
            2'b10: begin 
            // state == EXEC2
                MemSrc        = 1'b1;
                MemWrite      = 1'b0;
                MemRead       = 1'b0;
                ByteEn        = 4'b1111;
                RegSrc        = load_instr;
                RegData       = 2'b00;
                RegWrite      = load_instr;
                PCControl[1]  = 1'b1;
                PCControl[0]  = 1'b1;
                CntEn         = 1'b1;
                ALUSrc1       = 1'b0;
                ALUSrc2       = LW;
                ALUControl    = 5'b00000;
                Extra         = three_cycle_instr;
            end
            2'b11: begin 
            // state == HALT
            end
        endcase
    end

endmodule

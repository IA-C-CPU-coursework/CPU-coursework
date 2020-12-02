//-----------------------------------------------------------------------------
//  Decoder Module 
//-----------------------------------------------------------------------------

module mips_decoder(
    input [31:0] instruction, // instruction read from memory
    input [31:0] pc, // instruction location
    output halt, // asserted when trying to execute instruction from 0x0
    input branch,
    // state machine 
    input [1:0] state, 
    output logic extra,
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
    output logic ALUSrc,
    output logic Buffer,
    // program counter
    output logic [1:0] PCControl,
    output logic CntEn,
    // alu
    output logic [4:0] ALUControl
);

    assign halt = pc == 0;
    // halt when program counter output 0x0
    // should not halt when read from 0x0


    //-------------------------------------------------------------------------
    // Segments of instruction and their functionalities
    //-------------------------------------------------------------------------

    logic [5:0] opcode  = instruction[31:26]; // opcode is the first 6 significant bits
    logic [4:0] rs      = instruction[25:21]; // reg_src_1 
    logic [4:0] rt      = instruction[20:16]; // reg_src_2
    logic [4:0] rd      = instruction[15:11]; // write_addr also used to specify functions within the primary opcode value REGIMM
    logic [4:0] sa      = instruction[10:06]; // shift_amount
    logic [5:0] fncode  = instruction[05:00]; // fncode is the least 6 significant bits
    logic [15:0] offset = instruction[15:00]; 
    // 16-bit signed immediate used for: 
    //     logical operands, 
    //     arithmetic signed operands, 
    //     load/store address byte offsets, 
    //     PC-relative branch signed instruction displacement
    logic [25:0] instr_index = instruction[25:0]; // 26-bit index shifted left two bits to supply the low-order 28 bits of the jump target address


    //-------------------------------------------------------------------------
    // Decode Instructions
    // 
    // Three types 
    // 1. completely determined by `opcode`
    // 2. SPECIAL `opcode`, need `fncode`
    // 3. REGIMM `opcode`, need `rt`
    //-------------------------------------------------------------------------

    logic SPECIAL = opcode == 6'b000000;
    logic REGIMM  = opcode == 6'b000001;
    
    // arithmetic and logic
    logic ADDIU  = opcode == 6'b001001;
    logic ADDU   = SPECIAL && fncode == 6'b100001;
    logic AND    = SPECIAL && fncode == 6'b100100;
    logic ANDI   = opcode == 6'b001100;
    logic LUI    = opcode == 6'b001111;
    logic OR     = SPECIAL && fncode == 6'b100101;
    logic ORI    = opcode == 6'b001101;
    logic SLT    = SPECIAL && fncode == 6'b101010;
    logic SLTI   = opcode == 6'b001010;
    logic SLTIU  = opcode == 6'b001011;
    logic SLTU   = SPECIAL && fncode == 6'b101011;
    logic SUBU   = SPECIAL && fncode == 6'b100011;
    logic XOR    = SPECIAL && fncode == 6'b100110;
    logic XORI   = opcode == 6'b001110;

    // shift 
    logic SLL    = SPECIAL && fncode == 6'b000000;
    logic SLLV   = SPECIAL && fncode == 6'b000100;
    logic SRA    = SPECIAL && fncode == 6'b000011;
    logic SRAV   = SPECIAL && fncode == 6'b000111;
    logic SRL    = SPECIAL && fncode == 6'b000010;
    logic SRLV   = SPECIAL && fncode == 6'b000110;

    // multiply
    logic DIV    = SPECIAL && fncode == 6'b011010;
    logic DIVU   = SPECIAL && fncode == 6'b011011;
    logic MFHI   = SPECIAL && fncode == 6'b010000;
    logic MFLO   = SPECIAL && fncode == 6'b010010;
    logic MTHI   = SPECIAL && fncode == 6'b010001;
    logic MTLO   = SPECIAL && fncode == 6'b010011;
    logic MULT   = SPECIAL && fncode == 6'b011000;
    logic MULTU  = SPECIAL && fncode == 6'b011001;

    // branch
    logic BEQ    = opcode == 6'b000100;
    logic BGEZ   = REGIMM && rt == 5'b00001;
    logic BGEZAL = REGIMM && rt == 5'b10001;
    logic BGTZ   = opcode == 6'b000111;
    logic BLEZ   = opcode == 6'b000110;
    logic BLTZ   = REGIMM && rt == 5'b00000;
    logic BLTZAL = REGIMM && rt == 5'b10000;
    logic BNE    = opcode == 6'b000101;
    logic J      = opcode == 6'b000010;
    logic JAL    = opcode == 6'b000011;
    logic JALR   = SPECIAL && fncode == 6'b001001;
    logic JR     = SPECIAL && fncode == 6'b001000;

    // memory access
    logic LB     = opcode == 6'b100000;
    logic LBU    = opcode == 6'b100100;
    logic LH     = opcode == 6'b100001;
    logic LHU    = opcode == 6'b100101;
    logic LW     = opcode == 6'b100011;
    logic LWL    = opcode == 6'b100010;
    logic LWR    = opcode == 6'b100110;
    logic SB     = opcode == 6'b101000;
    logic SH     = opcode == 6'b101001;
    logic SW     = opcode == 6'b101011;

    // classification of instruction 
    logic load  = LB  || LBU || LH  || LHU || LW  || LWL || LWR;
    logic store = SB  || SH  || SW;
    logic three_cycle = load || store;
    logic two_cycle   = !three_cycle;


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
                Buffer      = 1'bx;
                RegSrc      = 1'bx;
                RegData     = 2'bxx;
                RegWrite    = 1'b0;
                PCControl   = 2'bxx;
                CntEn       = 1'b0;
                ALUSrc      = 1'bx;
                ALUControl  = 5'bxxxxx;
            end
            2'b01: begin 
            // state == EXEC1
                MemSrc       = 1'b1;
                MemWrite     = 1'b0;
                MemRead      = 1'b1;
                ByteEn       = 4'b1111;
                Buffer       = 1'b1;
                RegSrc       = ADDIU || ADDU;
                RegData      = 2'b10;
                RegWrite     = ADDIU || ADDU;
                PCControl[1] = ADDIU || ADDU || JR;
                PCControl[0] = ADDIU || ADDU;
                CntEn        = two_cycle;
                ALUSrc       = ADDU;
                ALUControl   = 5'b00000;
                extra        = three_cycle;
            end
            2'b10: begin 
            // state == EXEC2
                MemSrc       = 0;
                MemWrite     = store;
                MemRead      = load;
                ByteEn       = 4'b1111;
                Buffer       = 1'b1;
                RegSrc       = 1'b0;
                RegData      = 2'b00;
                RegWrite     = load;
                PCControl[1] = 1'b1;
                PCControl[0] = 1'b1;
                CntEn        = 1'b1;
                ALUSrc       = 1'b0;
                ALUControl   = 5'b00000;
            end
            2'b11: begin 
            // state == HALT
            end
        endcase
    end

endmodule

//-----------------------------------------------------------------------------
// ALU Module
//
// carry out required calculations based on ALUControl signal
// save result of multiplication and division into a internal 64-bit register 
//-----------------------------------------------------------------------------

module mips_alu(
    input clk,
    input [4:0] ALUControl,
    input [31:0] alu_src_1,
    input [31:0] alu_src_2,
    output logic [31:0] alu_result,
    output logic branch // this is a signal for J type instruction, branch if `branch` is asserted
);

    logic [63:0] HILO; // a 64-bit register specialised for division and multiplication
    // 63_____31______0
    //  |__HI__|__LO__|

    logic [31:0] HI;
    logic [31:0] LO; 
    assign HI = HILO[63:32];
    assign LO = HILO[31:0];

    logic [4:0] shift_amount;
    assign shift_amount = alu_src_1[4:0];
    integer load_enable = 0;
    integer load_byte;

    always_comb begin
        case(ALUControl)
        // carry out required calculations based on ALUControl signal 
        // following are calculations/operations not involving HILO register
            5'b00000:   alu_result[31:0] = alu_src_1[31:0]          +   alu_src_2[31:0];  // add (unsigned)
            5'b00001:   alu_result[31:0] = alu_src_1[31:0]          &   alu_src_2[31:0];  // and
            5'b00010:   ; // in the always_ff block below                                 // divide
            5'b00011:   branch           = alu_src_1[31:0]          ==  alu_src_2[31:0];  // equal to
            5'b00100:   branch           = $signed(alu_src_1[31:0]) >   0;  // greater than zero
            5'b00101:   branch           = $signed(alu_src_1[31:0]) >=  0;  // greater than or equal to zero, signed greater
            5'b00110:   branch           = $signed(alu_src_1[31:0]) <   0; // less than zero
            5'b00111:   branch           = $signed(alu_src_1[31:0]) <=  0;  // less than or equal to zero, signed comparison
            5'b01000:   ; // in the always_ff block below                                 // multiply
            5'b01001:   branch           = alu_src_1[31:0]          !=  alu_src_2[31:0];  // not equal to 
            5'b01010:   alu_result[31:0] = alu_src_1[31:0]          |   alu_src_2[31:0];  // or 
            5'b01011:   alu_result[31:0] = alu_src_2[31:0]          <<  shift_amount;     // shift to left logic 
            5'b01100:   alu_result[31:0] = $signed(alu_src_2[31:0]) >>> shift_amount;     // shift to right arithmetic 
            5'b01101:   alu_result[31:0] = alu_src_2[31:0]          >>  shift_amount;     // shift to right logic 
            5'b01110:   alu_result[31:0] = alu_src_1[31:0]          -   alu_src_2[31:0];  // subtract (unsigned)
            5'b01111:   alu_result[31:0] = alu_src_1[31:0]          ^   alu_src_2[31:0];  // xor
            5'b10000:   ; // in the always_ff block below                                 // Move to HI
            5'b10001:   alu_result[31:0] = HI;                                            // Move from HI
            5'b10010:   ; // in the always_ff block below                                 // Move to LO
            5'b10011:   alu_result[31:0] = LO;                                            // Move from LO
            5'b10100:   alu_result[31:0] = alu_src_2[31:0]          << 16'h10;            // shift lower 4 byte to upper
            5'b10101:   alu_result[31:0] = alu_src_1[31:0]           & (alu_src_2[31:0] & 32'h0000ffff); // andi
            5'b10110:   alu_result[31:0] = alu_src_1[31:0]         |  (alu_src_2[31:0] & 32'h0000ffff); // ori
            5'b10111:   alu_result[31:0] = alu_src_1[31:0]         ^ (alu_src_2[31:0] & 32'h0000ffff); // xori
            5'b11000:   alu_result[31:0] = ($signed(alu_src_1[31:0])    <   $signed(alu_src_2[31:0])); // (signed)for slt and slti
            5'b11001:   alu_result[31:0] = (alu_src_1[31:0]    <   alu_src_2[31:0]); // (usigned comparison) sltu and sltui
            5'b11010:   ; // add logics at the bottom block (signed multiplication calculation)
            5'b11011:   ; // add logics at the bottom block (signed division calculation)
            5'b11100:   alu_result[31:0] = alu_src_1[31:0]          +   $signed(alu_src_2[31:0] & 32'hfffffffc); //used for data transfer instructions; --- word aligned instructions only
            // for lwl and lwr
            5'b11101:   begin
                alu_result[31:0] = alu_src_1[31:0]          +   $signed(alu_src_2[31:0] & 32'hfffffffc);
            end 
            // this is for lwl instruction
            5'b11110:   begin
                case(load_byte)
                0: alu_result[31:0] = (alu_src_2[31:0] & 32'h00ffffff) + (alu_src_1[31:0] << 24);
                1: alu_result[31:0] = (alu_src_2[31:0] & 32'h0000ffff) + (alu_src_1[31:0] << 16);
                2: alu_result[31:0] = (alu_src_2[31:0] & 32'h000000ff) + (alu_src_1[31:0] << 8);
                3: alu_result[31:0] = alu_src_1[31:0];
                default: alu_result[31:0] = alu_src_1[31:0];
                endcase
                load_enable = 0;
            end 
             5'b11111:   begin
                case(load_byte)
                0: alu_result[31:0] = alu_src_1[31:0];
                1: alu_result[31:0] = (alu_src_2[31:0] & 32'hff000000) + (alu_src_1[31:0] >> 8);
                2: alu_result[31:0] = (alu_src_2[31:0] & 32'hffff0000) + (alu_src_1[31:0] >> 16);
                3: alu_result[31:0] = (alu_src_2[31:0] & 32'hffffff00) + (alu_src_1[31:0] >> 24);
                default: alu_result[31:0] = alu_src_1[31:0];
                endcase
                load_enable = 0;
            end
            default:    alu_result[31:0] = 32'bxxxxxxxx; 
            // output unknown signal as default behaviour
        endcase;
    end

    always_ff @(posedge clk)begin
        if((ALUControl == 5'b11101) && load_enable ==0)begin
            load_byte = alu_src_2[31:0] % 4;
            load_enable = 1;
        end
        case(ALUControl)
        // carry out required calculations based on ALUControl signal 
        // following are calculations/operations involving HILO register
            5'b00010:   begin 
                            HILO[63:32] <= alu_src_1[31:0] %  alu_src_2[31:0]; // unsigned divide
                            HILO[31:0]  <= alu_src_1[31:0] /  alu_src_2[31:0]; // unsigned divide
                        end
            5'b01000:   HILO[63:0]      <= alu_src_1[31:0] *  alu_src_2[31:0]; // unsigned multiply
            5'b10000:   HILO[63:32]     <= alu_result[31:0];                   // Move to HI
            5'b10010:   HILO[31:0]      <= alu_result[31:0];                   // Move to LO
            5'b11010:   HILO[63:0]      <= $signed(alu_src_1[31:0]) *  $signed(alu_src_2[31:0]); // signed multiply;
            5'b11011:   begin 
                            HILO[63:32] <= $signed(alu_src_1[31:0]) %  $signed(alu_src_2[31:0]); // signed divide
                            HILO[31:0]  <= $signed(alu_src_1[31:0]) /  $signed(alu_src_2[31:0]); // signed divide
                        end
        endcase;
    end
endmodule

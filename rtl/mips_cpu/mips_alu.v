//-----------------------------------------------------------------------------
// ALU Module
//
// carry out required calculations based on ALUControl signal
// save result of multiplication and division into a internal 64-bit register 
//-----------------------------------------------------------------------------

module mips_alu(
    input clk,
    input [5:0] ALUControl,
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

    logic byte_one;
    assign byte_one = alu_src_1[7];
    logic byte_two;
    assign byte_two = alu_src_1[15];
    logic byte_three;
    assign byte_three = alu_src_1[23];
    logic byte_four;
    assign byte_four = alu_src_1[31];



    logic [4:0] shift_amount;
    assign shift_amount = alu_src_1[4:0];
    integer load_enable = 0;
    integer load_byte;
    
    logic[3:0] byteenable_reg;

    always_comb begin
        case(ALUControl)
        // carry out required calculations based on ALUControl signal 
        // following are calculations/operations not involving HILO register
            6'b000000:   alu_result[31:0] = alu_src_1[31:0]          +   alu_src_2[31:0];  // add (unsigned)
            6'b000001:   alu_result[31:0] = alu_src_1[31:0]          &   alu_src_2[31:0];  // and
            6'b000010:   ; // in the always_ff block below                                 // divide
            6'b000011:   branch           = alu_src_1[31:0]          ==  alu_src_2[31:0];  // equal to
            6'b000100:   branch           = $signed(alu_src_1[31:0]) >   0;  // greater than zero
            6'b000101:   branch           = $signed(alu_src_1[31:0]) >=  0;  // greater than or equal to zero, signed greater
            6'b000110:   branch           = $signed(alu_src_1[31:0]) <   0; // less than zero
            6'b000111:   branch           = $signed(alu_src_1[31:0]) <=  0;  // less than or equal to zero, signed comparison
            6'b001000:   ; // in the always_ff block below                                 // multiply
            6'b001001:   branch           = alu_src_1[31:0]          !=  alu_src_2[31:0];  // not equal to 
            6'b001010:   alu_result[31:0] = alu_src_1[31:0]          |   alu_src_2[31:0];  // or 
            6'b001011:   alu_result[31:0] = alu_src_2[31:0]          <<  shift_amount;     // shift to left logic 
            6'b001100:   alu_result[31:0] = $signed(alu_src_2[31:0]) >>> shift_amount;     // shift to right arithmetic 
            6'b001101:   alu_result[31:0] = alu_src_2[31:0]          >>  shift_amount;     // shift to right logic 
            6'b001110:   alu_result[31:0] = alu_src_1[31:0]          -   alu_src_2[31:0];  // subtract (unsigned)
            6'b001111:   alu_result[31:0] = alu_src_1[31:0]          ^   alu_src_2[31:0];  // xor
            6'b010000:   ; // in the always_ff block below                                 // Move to HI
            6'b010001:   alu_result[31:0] = HI;                                            // Move from HI
            6'b010010:   ; // in the always_ff block below                                 // Move to LO
            6'b010011:   alu_result[31:0] = LO;                                           // Move from LO
            6'b010100:   alu_result[31:0] = alu_src_2[31:0]          << 16'h10;            // shift lower 4 byte to upper
            6'b010101:   alu_result[31:0] = alu_src_1[31:0]           & (alu_src_2[31:0] & 32'h0000ffff); // andi
            6'b010110:   alu_result[31:0] = alu_src_1[31:0]         |  (alu_src_2[31:0] & 32'h0000ffff); // ori
            6'b010111:   alu_result[31:0] = alu_src_1[31:0]         ^ (alu_src_2[31:0] & 32'h0000ffff); // xori
            6'b011000:   alu_result[31:0] = ($signed(alu_src_1[31:0])    <   $signed(alu_src_2[31:0])); // (signed)for slt and slti
            6'b011001:   alu_result[31:0] = (alu_src_1[31:0]    <   alu_src_2[31:0]); // (usigned comparison) sltu and sltui
            6'b011010:   ; // add logics at the bottom block (signed multiplication calculation)
            6'b011011:   ; // add logics at the bottom block (signed division calculation)
            6'b011100:   alu_result[31:0] = alu_src_1[31:0]          +   $signed(alu_src_2[31:0] & 32'hfffffffc); //used for data transfer instructions; --- word aligned instructions only
            // for lwl and lwr
            6'b011101:   begin
                alu_result[31:0] = alu_src_1[31:0]          +   $signed(alu_src_2[31:0] & 32'hfffffffc);
            end 
            // this is for lwl instruction
            6'b011110:   begin
                case(load_byte)
                0: alu_result[31:0] = (alu_src_2[31:0] & 32'h00ffffff) + (alu_src_1[31:0] << 24);
                1: alu_result[31:0] = (alu_src_2[31:0] & 32'h0000ffff) + (alu_src_1[31:0] << 16);
                2: alu_result[31:0] = (alu_src_2[31:0] & 32'h000000ff) + (alu_src_1[31:0] << 8);
                3: alu_result[31:0] = alu_src_1[31:0];
                default: alu_result[31:0] = alu_src_1[31:0];
                endcase
                load_enable = 0;
            end 
             6'b011111:   begin
                case(load_byte)
                0: alu_result[31:0] = alu_src_1[31:0];
                1: alu_result[31:0] = (alu_src_2[31:0] & 32'hff000000) + (alu_src_1[31:0] >> 8);
                2: alu_result[31:0] = (alu_src_2[31:0] & 32'hffff0000) + (alu_src_1[31:0] >> 16);
                3: alu_result[31:0] = (alu_src_2[31:0] & 32'hffffff00) + (alu_src_1[31:0] >> 24);
                default: alu_result[31:0] = alu_src_1[31:0];
                endcase
                load_enable = 0;
            end
            // LB
            6'b100000: begin
                case(load_byte)
                0:alu_result[31:0] = byte_one ? (alu_src_1[31:0] | 32'hffffff00) : alu_src_1[31:0];
                1:alu_result[31:0] = byte_two ? ((alu_src_1[31:0] >> 8) | 32'hffffff00) : (alu_src_1[31:0] >> 8);
                2:alu_result[31:0] = byte_three ? ((alu_src_1[31:0] >> 16) | 32'hffffff00) : (alu_src_1[31:0] >> 16);
                3:alu_result[31:0] = byte_four ? ((alu_src_1[31:0] >> 24) | 32'hffffff00) : (alu_src_1[31:0] >> 24);
                default: alu_result[31:0] = alu_src_1[31:0];
                endcase
                load_enable = 0;
            end
            6'b100001: begin
                case(load_byte)
                0:alu_result[31:0] = alu_src_1[31:0];
                1:alu_result[31:0] =(alu_src_1[31:0] >> 8) ;
                2:alu_result[31:0] = (alu_src_1[31:0] >> 16);
                3:alu_result[31:0] = (alu_src_1[31:0] >> 24);
                default: alu_result[31:0] = alu_src_1[31:0];
                endcase
                load_enable = 0;
            end

            default:    alu_result[31:0] = 32'bxxxxxxxx; 
            // output unknown signal as default behaviour
        endcase;
    end

    always_ff @(posedge clk)begin


        if((ALUControl == 6'b011101) && load_enable ==0)begin
            load_byte = alu_src_2[31:0] % 4;
            load_enable = 1;
        end
        case(ALUControl)
        // carry out required calculations based on ALUControl signal 
        // following are calculations/operations involving HILO register
            6'b000010:   begin 
                            HILO[63:32] <= alu_src_1[31:0] %  alu_src_2[31:0]; // unsigned divide
                            HILO[31:0]  <= alu_src_1[31:0] /  alu_src_2[31:0]; // unsigned divide
                        end
            6'b001000:   HILO[63:0]      <= alu_src_1[31:0] *  alu_src_2[31:0]; // unsigned multiply
            6'b010000:   HILO[63:32]    <= alu_src_1[31:0];                   // Move to HI
            6'b010010:   HILO[31:0]     <= alu_src_1[31:0];                   // Move to LO
            6'b011010:   HILO[63:0]      <= $signed(alu_src_1[31:0]) *  $signed(alu_src_2[31:0]); // signed multiply;
            6'b011011:   begin 
                            HILO[63:32] <= $signed(alu_src_1[31:0]) %  $signed(alu_src_2[31:0]); // signed divide
                            HILO[31:0]  <= $signed(alu_src_1[31:0]) /  $signed(alu_src_2[31:0]); // signed divide
                        end
        endcase;
    end
endmodule

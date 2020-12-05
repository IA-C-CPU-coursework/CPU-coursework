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

    always_comb begin
        case(ALUControl)
        // carry out required calculations based on ALUControl signal 
        // following are calculations/operations not involving HILO register
            5'b00000:   alu_result[31:0] = alu_src_1[31:0] +   alu_src_2[31:0]; // add (unsigned)
            5'b00001:   alu_result[31:0] = alu_src_1[31:0] &   alu_src_2[31:0]; // and
            5'b00010:   ; // in the always_ff block below                       // divide
            5'b00011:   branch           = alu_src_1[31:0] ==  alu_src_2[31:0]; // equal to
            5'b00100:   branch           = alu_src_1[31:0] >   alu_src_2[31:0]; // greater than 
            5'b00101:   branch           = alu_src_1[31:0] >=  alu_src_2[31:0]; // greater than or equal to 
            5'b00110:   branch           = alu_src_1[31:0] <   alu_src_2[31:0]; // less than 
            5'b00111:   branch           = alu_src_1[31:0] <=  alu_src_2[31:0]; // less than or equal to 
            5'b01000:   ; // in the always_ff block below                       // multiply
            5'b01001:   branch           = alu_src_1[31:0] !=  alu_src_2[31:0]; // not equal to 
            5'b01010:   alu_result[31:0] = alu_src_1[31:0] |   alu_src_2[31:0]; // or 
            5'b01011:   alu_result[31:0] = alu_src_1[31:0] <<  alu_src_2[31:0]; // shift to left logic 
            5'b01100:   alu_result[31:0] = alu_src_1[31:0] >>> alu_src_2[31:0]; // shift to right arithmetic 
            5'b01101:   alu_result[31:0] = alu_src_1[31:0] >>  alu_src_2[31:0]; // shift to right logic 
            5'b01110:   alu_result[31:0] = alu_src_1[31:0] -   alu_src_2[31:0]; // subtract (unsigned)
            5'b01111:   alu_result[31:0] = alu_src_1[31:0] ^   alu_src_2[31:0]; // xor
            5'b10000:   ; // in the always_ff block below                       // Move to HI
            5'b10001:   alu_result[31:0] = HI;                                  // Move from HI
            5'b10010:   ; // in the always_ff block below                       // Move to LO
            5'b10011:   alu_result[31:0] = LO;                                  // Move from LO
            5'b10100:   alu_result[31:0] = alu_src_2[31:0] << 16'h10;               // shift lower 2 byte to upper
            default:    alu_result[31:0] = 32'bxxxxxxxx; 
            // output unknown signal as default behaviour
        endcase;
    end

    always_ff @(posedge clk)begin
        case(ALUControl)
        // carry out required calculations based on ALUControl signal 
        // following are calculations/operations involving HILO register
            5'b00010:   begin 
                            HILO[63:32] <= alu_src_1[31:0] %  alu_src_2[31:0]; // divide
                            HILO[31:0]  <= alu_src_1[31:0] /  alu_src_2[31:0]; // divide
                        end
            5'b01000:   HILO[63:0]      <= alu_src_1[31:0] *  alu_src_2[31:0]; // multiply
            5'b10000:   HILO[63:32]     <= alu_result[31:0];                   // Move to HI
            5'b10010:   HILO[31:0]      <= alu_result[31:0];                   // Move to LO
        endcase;
    end
endmodule

module ALU(
    input [2:0] ALUcontrol,
    input [31:0] A,B,
    output [31:0] ALUout,
    output isZero
    );

assign isZero = (ALUout==0);

always_comb begin
    case(ALUcontrol)//different ALUControl inputs serve different operations
    0: ALUout = A&B;
    1: ALUout = A|B;
    2: ALUout = A+B;
    6: ALUout = A-B;
    7: ALUout = A<B;
    default: ALUout = 0;
    endcase
end
endmodule

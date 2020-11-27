module mips_sign_extension(
    input [15:0] i,
    output [31:0] o
    );

    assign o[15:0] = i[15:0];
    assign o[31:16] = i[15];
endmodule

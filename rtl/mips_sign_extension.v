module SignExtension(
    input [15:0] i,
    output [31:0] o
    );

    assign out[15:0] = in[15:0];
    assign out[31:16] = in[15];
endmodule
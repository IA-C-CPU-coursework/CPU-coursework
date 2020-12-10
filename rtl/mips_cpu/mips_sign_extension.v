module mips_sign_extension(
    input [15:0] offset,
    output [31:0] signed_offset
    );

    assign signed_offset[15:0] = offset[15:0];
    assign signed_offset[31:16] = offset[15] ? 16'hffff : 16'h0000;
    // assign o[31:16] = {16{i[15]}}; // just another way
endmodule

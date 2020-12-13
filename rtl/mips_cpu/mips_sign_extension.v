module mips_sign_extension(
    input [15:0] offset,
    input  extension_control,
    output [31:0] signed_offset
    );

    logic[31:0] half_extension;

    assign half_extension[15:0] = offset[25:0];
    assign half_extension[31:16] = offset[15] ? 16'hffff : 16'h0000;

    logic[31:0] byte_extension;

    assign byte_extension[7:0] = offset[7:0];
    assign byte_extension[31:8] = offset[7]? 24'hffffff : 24'h000000;

    assign signed_offset[31:0] = extension_control ? byte_extension[31:0] : half_extension[31:0];

    //assign signed_offset[15:0] = offset[15:0];
    //assign signed_offset[31:16] = offset[15] ? 16'hffff : 16'h0000;
    // assign o[31:16] = {16{i[15]}}; // just another way
endmodule

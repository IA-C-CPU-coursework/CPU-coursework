module mips_remainder(
    input [31:0] alu_src_2,
    output logic[3:0] byte_remainder
);


logic[31:0] remainder;
assign remainder[31:0] = alu_src_2[31:0] % 4;

always_comb begin
if(remainder == 0)begin
    byte_remainder[3:0] = 4'b0001;
end
else if(remainder == 1)begin
    byte_remainder[3:0] = 4'b0010;
end
else if(remainder == 2)begin
    byte_remainder[3:0] = 4'b0100;
end
else if(remainder == 3)begin
    byte_remainder[3:0] = 4'b1000;
end
else begin
    byte_remainder[3:0] = 4'b1111;
end
end 
endmodule
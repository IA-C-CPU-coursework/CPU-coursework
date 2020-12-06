module mips_program_counter(
    input clk,
    input rst,
    input CntEn,
    input [1:0] PCControl,
    input [31:0] read_data_1,
    input [31:0] signed_offset,
    input [25:0] target,
    output logic[31:0] pc
);
    initial begin 
        pc[31:0] <= 32'hBFC00000;
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            pc[31:0] <= 32'hBFC00000;
        end 
        else if(CntEn) begin
            case(PCControl)
                2'b00: pc[31:0] <= pc[31:0]  + signed_offset[15:0] << 2;
                2'b01: pc[31:0] <= {pc[31:28], target, 2'b00};
                2'b10: pc[31:0] <= read_data_1[31:0];
                2'b11: pc[31:0] <= pc[31:0]  + 4;
                default: pc[31:0] <= 32'hxxxxxxxx;
            endcase
        end
    end
endmodule

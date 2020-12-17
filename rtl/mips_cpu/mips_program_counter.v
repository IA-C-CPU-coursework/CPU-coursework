module mips_program_counter(
    input clk,
    input rst,
    input CntEn,
    input is_branch,
    input [1:0] PCControl,
    input [31:0] read_data_1,
    input [31:0] signed_offset,
    input [25:0] target,
    output logic[31:0] pc
);
    initial begin 
        pc[31:0] <= 32'hBFC00000;
    end

integer in_branch_delay;
logic[31:0] branch_address;

    always_ff @(posedge clk) begin
        if(rst) begin
            pc[31:0] <= 32'hBFC00000;
        end 
        else if(CntEn) begin
            if(!is_branch)begin
                if(in_branch_delay==1)begin
                    in_branch_delay = 0;
                    pc[31:0] <= branch_address[31:0];
                end
                else begin
                    pc[31:0] <= pc[31:0] + 4;
                end
            end
            else if(is_branch)begin
                in_branch_delay = 1;
                case(PCControl)
<<<<<<< HEAD
                2'b00: branch_address[31:0] <= pc[31:0] + 4 +(signed_offset[31:0] << 2);
=======
                2'b00: branch_address[31:0] <= pc[31:0] + 4 + (signed_offset[31:0] << 2);
>>>>>>> origin
                2'b01: branch_address[31:0] <= {pc[31:28], target, 2'b00};
                2'b10: branch_address[31:0] <= read_data_1[31:0] & 32'hfffffffc;
                default: branch_address[31:0] <= 32'hxxxxxxxx;
            endcase
                pc[31:0] <= pc[31:0] + 4;
            end
            
        end
    end
endmodule

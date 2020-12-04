//-----------------------------------------------------------------------------
// Instruction Register
// 
// keep the previous mem_out in EXEC2 cycle, i.e. when loading data from memory
// directly return mem_out otherwise 
//-----------------------------------------------------------------------------


module mips_instruction_register(
    input clk,
    input [31:0] mem_out,
    input [1:0] state,
    output [31:0] mem_out_buffer
);
    logic [31:0] buffer; // temporary storage of mem_out
    
    assign mem_out_buffer = state == 2'b10 ? buffer : mem_out; // keep the previous mem_out in EXEC2 cycle, i.e. when loading data from memory

    always_ff @(posedge clk) begin
        if (state != 2'b10) begin 
        // only buffer instructions
        // data comes out from memory when state == 2'b10
            buffer <= mem_out;
        end
    end
endmodule

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
    output logic [31:0] mem_out_buffer
);
    always_ff @(posedge state[0]) begin
        // only buffer instructions at the first cycle in `EXEC1` state
        mem_out_buffer <= mem_out;
    end
endmodule

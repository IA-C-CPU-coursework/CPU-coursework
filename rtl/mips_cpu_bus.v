//-----------------------------------------------------------------------------
// MIPS CPU with Bus Shared Interface
//-----------------------------------------------------------------------------


`include "mips_alu.v"
`include "mips_program_counter.v"
`include "mips_decoder.v"
`include "mips_state_machine.v"
`include "mips_sign_extension.v"
`include "mips_reg_file.v"


module mips_cpu_bus(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

    //-------------------------------------------------------------------------
    // Wiring 
    //-------------------------------------------------------------------------

    // mem_out[31:0]
    logic[4:0] rs;
    logic[4:0] rt;
    logic[4:0] rd;

    assign rs = mem_out[25:21];
    assign rt = mem_out[20:16];
    assign rd = mem_out[15:11];

    // memory
    logic MemWrite;
    logic MemRead;
    logic[3:0] ByteEn;
    logic[31:0] mem_in;
    logic[31:0] mem_out;
    // logic waitrequest;
    logic mem_addr;

    // register file 
    logic RegWrite;
    logic[4:0] write_addr;
    logic[31:0] write_data;
    logic[4:0] read_addr_1;
    logic[4:0] read_addr_2;
    logic[31:0] read_data_1;
    logic[31:0] read_data_2;

    // ALU
    logic [4:0] ALUControl;
    logic [31:0] alu_src_1;
    logic [31:0] alu_src_2;
    logic [31:0] alu_result;
    logic branch;

    // program counter
    logic CntEn;
    logic [1:0]PCControl;
    logic [31:0] pc;
    // logic [31:0] read_data_1;
    // logic [31:0] signed_offset;
    logic [25:0] target;

    // sign extension
    logic [15:0] offset;
    logic [31:0] signed_offset;

    // signals required by mips_state_machines
    logic halt;
    logic extra;
    // logic waitrequest;
    logic[1:0] state;

    // decoder 
    logic MemSrc;
    logic RegSrc;
    logic [1:0]RegData;
    logic ALUSrc;
    logic Buffer;
    // logic MemWrite;
    // logic MemRead;
    // logic ByteEn;
    // logic RegWrite;
    // logic CntEn;
    // logic ALUControl;
    // logic PCControl;

    //-------------------------------------------------------------------------
    // Multiplexer
    //-------------------------------------------------------------------------

    assign mem_addr = MemSrc ? pc : alu_result;
    assign alu_src_2 = ALUSrc ? read_data_2 : signed_offset;
    assign write_addr = RegSrc ? rt : rd;
    always_comb begin
        case(RegData)
            2'b00: write_data[31:0] = mem_out[31:0];
            2'b01: write_data[31:0] = pc[31:0];
            2'b10: write_data[31:0] = alu_result[31:0];
        endcase
    end

    //-------------------------------------------------------------------------
    // Module Instanciation 
    //-------------------------------------------------------------------------

    // instanciation of mips_reg_file
    mips_reg_file regFile(
        .rst(reset),
        .clk(clk),
        .RegWrite(write),
        .write_addr(write_addr),
        .read_addr_1(read_addr_1),
        .read_addr_2(read_addr_2),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // instanciation of mips_sign_extension
    mips_sign_extension signExt(
        .offset(offset),
        .signed_offset(signed_offset)
    );

    // instantiation of mips_state_machine
    mips_state_machine stateMachine(
        .rst(reset),
        .clk(clk),
        .halt(halt),
        .extra(extra),
        .waitrequest(waitrequest),
        .s(state)
    );

    // instantiation of mips_decoder
    mips_decoder decoder(
        .instruction(mem_out), // instruction read from memory
        .pc(pc), // instruction location
        .halt(halt), // asserted when trying to execute instruction from 0x0
        .branch(branch),
        // state machine 
        .state(state), 
        .extra(extra),
        // momery
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ByteEn(ByteEn),
        // register file 
        .RegWrite(RegWrite),
        .RegData(RegData),
        // multiplexer 
        .MemSrc(MemSrc),
        .RegSrc(RegSrc),
        .ALUSrc(ALUSrc),
        .Buffer(Buffer),
        // program counter
        .PCControl(PCControl),
        .CntEn(CntEn),
        // alu
        .ALUControl(ALUControl)
    );

    // instantiation of mips_alu
    mips_alu alu(
        .clk(clk),
        .ALUControl(ALUControl),
        .alu_src_1(alu_src_1),
        .alu_src_2(alu_src_2),
        .alu_result(alu_result),
        .branch(branch)
    );

endmodule

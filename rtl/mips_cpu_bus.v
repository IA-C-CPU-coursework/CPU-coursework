//-----------------------------------------------------------------------------
// MIPS CPU with Bus Shared Interface
//-----------------------------------------------------------------------------


// `include "mips_alu.v"
// `include "mips_program_counter.v"
// `include "mips_decoder.v"
// `include "mips_state_machine.v"
// `include "mips_sign_extension.v"
// `include "mips_reg_file.v"
// `include "mips_instruction_register.v"


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
    // Activation 
    //-------------------------------------------------------------------------

    initial begin 
        active = 1'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            $display("[CPU] : RESET");
            active <= 1;
        end
        if (Halt) begin
            active <= 0;
        end
    end

    always @(negedge active) begin
        $display("[CPU] : HALT");
    end

    //-------------------------------------------------------------------------
    // Wiring 
    //-------------------------------------------------------------------------

    // mem_out[31:0]
    logic[4:0] rs;
    logic[4:0] rt;
    logic[4:0] rd;

    assign rs = mem_out_buffer[25:21];
    assign rt = mem_out_buffer[20:16];
    assign rd = mem_out_buffer[15:11];

    // memory
    logic MemWrite;
        assign write = MemWrite;
    logic MemRead;
        assign read = MemRead;
    //logic[3:0] ByteEn;
      //  assign byteenable = ByteEn;
    assign writedata = read_data_2;
    logic[31:0] mem_out;
        assign mem_out = readdata;
    // logic waitrequest;
    logic[31:0] mem_addr;

    // register file 
    logic RegWrite;
    logic[4:0] write_addr;
    logic[31:0] write_data;
    logic[4:0] read_addr_1;
        assign read_addr_1 = rs;
    logic[4:0] read_addr_2;
        assign read_addr_2 = rt;
    logic[31:0] read_data_1;
    logic[31:0] read_data_2;
    logic[31:0] v0;
        assign register_v0 = v0;

    // ALU
    logic [5:0] ALUControl;
    logic [31:0] alu_src_1;
    logic [31:0] alu_src_2;
    logic [4:0] shift_amount;
        assign shift_amount = signed_offset[10:6];
    logic [31:0] alu_result;
    logic branch;

    // program counter
    logic CntEn;
    logic [1:0]PCControl;
    logic [31:0] pc;
    // logic [31:0] read_data_1;
    // logic [31:0] signed_offset;
    logic [25:0] target;
    assign target = mem_out[25:0];
    logic is_branch;

    // sign extension
    logic [15:0] offset;
        assign offset = mem_out[15:0];
    logic [31:0] signed_offset;
    logic extension_control;

    // signals required by mips_state_machines
    logic Halt;
    logic Extra;
    // logic waitrequest;
    logic[1:0] state;

    // decoder 
    logic MemSrc;
    logic RegSrc;
    logic [1:0]RegData;
    logic ALUSrc1;
    logic ALUSrc2;
    logic Buffer;
    logic link;
    logic unaligned;
    logic alu_src_mem;
    // logic MemWrite;
    // logic MemRead;
    // logic ByteEn;
    // logic RegWrite;
    // logic CntEn;
    // logic ALUControl;
    // logic PCControl;

    // instruction register
    // logic [31:0] mem_out;
    logic [31:0] mem_out_buffer;


    // to calculate the remaider of  address offset
    logic [3:0] byte_remainder;
    logic [3:0] ByteEn_de;
    //-------------------------------------------------------------------------
    // Multiplexer
    //-------------------------------------------------------------------------

    assign byteenable = unaligned ? byte_remainder : ByteEn_de;
    assign mem_addr = MemSrc ? pc : alu_result;
    assign address = mem_addr;
    assign alu_src_1[31:0] = alu_src_mem ? (mem_out[31:0]) : (ALUSrc1 ? {27'b0, shift_amount}: read_data_1[31:0]);
    assign alu_src_2[31:0] = ALUSrc2 ? signed_offset[31:0] : read_data_2[31:0];
    assign write_addr = link ? (5'b11111):(RegSrc ? rt : rd);
    always_comb begin
        case(RegData)
            2'b00: write_data[31:0] = alu_result[31:0]; //write_data[31:0] = mem_out[31:0];
            2'b01: write_data[31:0] = mem_out[31:0];//write_data[31:0] = pc[31:0];
            2'b10: write_data[31:0] = pc[31:0]+8;
            2'b11: write_data[31:0] = signed_offset[31:0];
            default: write_data = 32'hxxxxxxxx;
        endcase
    end

    //-------------------------------------------------------------------------
    // Module Instanciation 
    //-------------------------------------------------------------------------

    // instantiation of program counter
    mips_program_counter PC(
        .clk(clk),
        .rst(reset),
        .CntEn(CntEn),
        .is_branch(is_branch),
        .PCControl(PCControl),
        .read_data_1(read_data_1),
        .signed_offset(signed_offset),
        .target(target),
        .pc(pc)
    );

    // instantiation of instruction register
    mips_instruction_register instrReg(
        .clk(clk),
        .state(state),
        .mem_out(mem_out),
        .mem_out_buffer(mem_out_buffer)
    );

    // instantiation of mips_reg_file
    mips_reg_file regFile(
        .rst(reset),
        .clk(clk),
        .RegWrite(RegWrite),
        .write_addr(write_addr),
        .read_addr_1(read_addr_1),
        .read_addr_2(read_addr_2),
        .write_data(write_data),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .v0(v0)
    );

    // instantiation of mips_sign_extension
    mips_sign_extension signExt(
        .offset(offset),
        .extension_control(extension_control),
        .signed_offset(signed_offset)
    );

    // instantiation of mips_state_machine
    mips_state_machine stateMachine(
        .rst(reset),
        .clk(clk),
        .Halt(Halt),
        .Extra(Extra),
        .waitrequest(waitrequest),
        .s(state)
    );

    // instantiation of mips_decoder
    mips_decoder decoder(
        .instruction(mem_out_buffer), // instruction read from memory
        .pc(pc), // instruction location
        .waitrequest(waitrequest),
        .Halt(Halt), // asserted when trying to execute instruction from 0x0
        .branch(branch),
        // state machine 
        .state(state), 
        .Extra(Extra),
        // momery
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ByteEn_de(ByteEn_de),
        // register file 
        .RegWrite(RegWrite),
        .RegData(RegData),
        // multiplexer 
        .MemSrc(MemSrc),
        .RegSrc(RegSrc),
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        // program counter
        .PCControl(PCControl),
        .CntEn(CntEn),
        // alu
        .ALUControl(ALUControl),
        .is_branch(is_branch),
        .link(link),
        .extension_control(extension_control),
        .unaligned(unaligned),
        .alu_src_mem(alu_src_mem)
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

    //to calculate specific byte location
    mips_remainder byte_calculation(
        .alu_src_2(alu_src_2),
        .byte_remainder(byte_remainder)
    );

endmodule

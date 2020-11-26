module control(
    input instruction[31:0],
// Determine output signals that must be controlled

    output RegWrite, MemWrite, ALUSrc, ALUControl, 
    
);
    //MAKE SURE TO CHANGE WIRE NAME OF THINGY
    wire opcode = instruction [31:26];
    wire FuncCode = instruction [5:0];
/*    

    
always_comb begin
    if (opcode == 0 && FuncCode == 6'b100001) begin //ADDU
        //SET CONTROLS
    end
    else if (opcode == 6'b001001) begin //ADDIU
    end
    else if (opcode == 0 && FuncCode == 6'b100100) begin //AND
    end
    else if (opcode == 6'b001100) begin //ANDI
    end
    else if (opcode == 6'b000100) begin //BEQ
    end
    else if (opcode == 6'b000001 ) begin //BGEZ
    end
    else if (opcode == 6'b000001) begin //BGEZAL
    end
    else if (opcode == 6'bxxxxxx) begin //BGTZ
    end
    else if (opcode == 6'bxxxxxx) begin //BLEZ
    end
    else if (opcode == 6'bxxxxxx) begin //BLTZ
    end
    else if (opcode == 6'bxxxxxx) begin//BLTZAL
    end
    else if (opcode == 6'bxxxxxx) begin //BNE
    end
    else if (opcode == 6'bxxxxxx) begin //DIV
    end
    else if (opcode == 6'bxxxxxx) begin //DIVU
    end
    else if (opcode == 6'bxxxxxx) begin //J
    end
    else if (opcode == 6'bxxxxxx) begin //JALR
    end
    else if (opcode == 6'bxxxxxx) begin //JAL
    end
    else if (opcode == 6'bxxxxxx) begin //JR
    end
    else if (opcode == 6'bxxxxxx) begin //LB
    end
    else if (opcode == 6'bxxxxxx) begin //LBU
    end
    else if (opcode == 6'bxxxxxx) begin //LH
    end
    else if (opcode == 6'bxxxxxx) begin //LHU
    end
    else if (opcode == 6'bxxxxxx) begin //LUI
    end
    else if (opcode == 6'bxxxxxx) begin //LW
    end
    else if (opcode == 6'bxxxxxx) begin //LWL
    end
    else if (opcode == 6'bxxxxxx) begin //LWR
    end
    else if (opcode == 6'bxxxxxx) begin //MTHI
    end
    else if (opcode == 6'bxxxxxx) begin //MTLO
    end
    else if (opcode == 6'bxxxxxx) begin //MULT
    end
    else if (opcode == 6'bxxxxxx) begin //MULTU
    end
    else if (opcode == 6'bxxxxxx) begin //OR
    end
    else if (opcode == 6'bxxxxxx) begin //ORI
    end
    else if (opcode == 6'bxxxxxx) begin //SB
    end
    else if (opcode == 6'bxxxxxx) begin //SH
    end
    else if (opcode == 6'bxxxxxx) begin //SLL
    end
    else if (opcode == 6'bxxxxxx) begin //SLLV
    end
    else if (opcode == 6'bxxxxxx) begin //SLT
    end
    else if (opcode == 6'bxxxxxx) begin //SLTI
    end
    else if (opcode == 6'bxxxxxx) begin //SLTIU
    end
    else if (opcode == 6'bxxxxxx) begin //SLTU
    end
    else if (opcode == 6'bxxxxxx) begin //SRA
    end
    else if (opcode == 6'bxxxxxx) begin //SRAV
    end
    else if (opcode == 6'bxxxxxx) begin //SRL
    end
    else if (opcode == 6'bxxxxxx) begin //SRLV
    end
    else if (opcode == 6'bxxxxxx) begin //SUBU
    end
    else if (opcode == 6'bxxxxxx) begin //SW
    end
    else if (opcode == 6'bxxxxxx) begin //XOR
    end
    else if (opcode == 6'bxxxxxx) begin //XORI
    end
    else begin
    end


end

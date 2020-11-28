module mips_control_unit(
    input [5:0] opcode, 
    input [5:0] FuncCode,
    input reset,
// Determine output signals that must be controlled

    output RegWrite, MemtoReg, ALUSrc, MemRead, MemWrite, RegDst, branch, jump
    output logic [2:0] ALUControl
    
);
    
always_comb begin
    case(opcode)
/*    
    6'b000000: begin //Opcode == 0 (ADDU, AND)
        if (FuncCode == 6'b100001) begin //ADDU
            
        end
        else if (FuncCode == 6'b100100) begin // AND
        
        end
    end */
    6'b001001: begin //ADDIU **
        ALUSrc = 1;
        ALUControl = 2;
        RegWrite = 1;
        MemtoReg = ;
        MemRead = 1;
        MemWrite = 0;
        RegDst = 1;
        branch = 0;
        jump = 0;
    end

/*
    6'b001100: begin //ANDI
    end
    6'b000100: begin //BEQ
    end
    6'b000001: begin //BGEZ
    end
    6'b000001 begin //BGEZAL
    end
    6'bxxxxxx: begin //BGTZ
    end
    6'bxxxxxx: begin //BLEZ
    end
    6'bxxxxxx: begin //BLTZ
    end
    6'bxxxxxx: begin//BLTZAL
    end
    6'bxxxxxx: begin //BNE
    end
    6'bxxxxxx: begin //DIV
    end
    6'bxxxxxx: begin //DIVU
    end
    6'bxxxxxx: begin //J
    end
    6'bxxxxxx: begin //JALR
    end
    6'bxxxxxx: begin //JAL
    end
    6'bxxxxxx: begin //JR **
    end
    6'bxxxxxx: begin //LB
    end
    6'bxxxxxx: begin //LBU
    end
    6'bxxxxxx: begin //LH
    end
    6'bxxxxxx: begin //LHU
    end
    6'bxxxxxx: begin //LUI
    end
    6'bxxxxxx: begin //LW **
    end
    6'bxxxxxx: begin //LWL
    end
    6'bxxxxxx: begin //LWR
    end
    6'bxxxxxx: begin //MTHI
    end
    6'bxxxxxx: begin //MTLO
    end
    6'bxxxxxx: begin //MULT
    end
    6'bxxxxxx: begin //MULTU
    end
    6'bxxxxxx: begin //OR
    end
    6'bxxxxxx: begin //ORI
    end
    6'bxxxxxx: begin //SB
    end
    6'bxxxxxx: begin //SH
    end
    6'bxxxxxx: begin //SLL
    end
    6'bxxxxxx: begin //SLLV
    end
    6'bxxxxxx: begin //SLT
    end
    6'bxxxxxx: begin //SLTI
    end
    6'bxxxxxx: begin //SLTIU
    end
    6'bxxxxxx: begin //SLTU
    end
    6'bxxxxxx: begin //SRA
    end
    6'bxxxxxx: begin //SRAV
    end
    6'bxxxxxx: begin //SRL
    end
    6'bxxxxxx: begin //SRLV
    end
    6'bxxxxxx: begin //SUBU
    end
    6'bxxxxxx: begin //SW **
    end
    6'bxxxxxx: begin //XOR
    end
    6'bxxxxxx: begin //XORI
    end */
    endcase


end
endmodule
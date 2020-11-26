module control(
    input instruction[31:0],
// Determine output signals that must be controlled

    output RegWrite, MemWrite, ALUSrc, ALUControl, 
    
);
    //MAKE SURE TO CHANGE WIRE NAME OF THINGY
    wire opcode = instruction [31:26];
    wire FuncCode = instruction [5:0];
/*    
always @(reset) begin
    if(reset==1) begin
    #1
        if (reset==1) begin
            
        end
    end
end */
    
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
    else if () begin
    end
    else if () begin
    end
    else if () begin
    end
    else if () begin
    end
    else if (opcode == 6'bxxxxxx) begin
    end
end

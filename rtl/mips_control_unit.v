module control(
    input[2:0] opcode, 
    input reset,
    output  // Determine output signals that must be controlled
)
always_comb begin
    if (reset == 1) begin

    end
    else begin
        case(opcode)
        0: begin //add
            
        end
        1: begin //sli
            
        end
        2: begin //jump
            
        end
        3: begin // jump and link
            
        end
        4: begin
            
        end
        5: begin
            
        end // etc
    end
end
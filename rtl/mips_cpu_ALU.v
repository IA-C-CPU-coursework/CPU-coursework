module mips_cpu_ALU(
    input logic[31:0] a,
    input logic[31:0] b,
    input logic[3:0] control,
    output logic[31:0],
    //including flags:
    output logic zero,
    output logic carry,
    output logic overflow
);
logic [32:0] inter;

always_com begin
    //AND
    //update zero flag, but keep overflow and carry zero
    if(control = 2'b0000) begin
        carray = 0;
        overflow = 0;
        r = a & b;
        if(r == 0)  zero = 1;
        else zero = 0;
    end
    //OR
    //update zero flag, but keep overflow and carry zero
    else if(control = 2'b0001) begin
        carray = 0;
        overflow = 0;
        r = a | b;
        if(r == 0)  zero = 1;
        else zero = 0;
    end
    //add,update zero,overflow,and carry flags
    else if(control = 2'b0010) begin
         r = a+b;
        inter = a+b;
        if(inter[32] == 1'b1)begin
            carry = 1;
            overflow = 1;
        end
        else begin
            carry = 0;
        end
        if(r == 0)  zero = 1;
        else zero = 0;
    end
    //sub,update zero,overflow,and carry flags
    else if(control = 2'b0110) begin
        r = a - b;
        inter = a - b;
        if(inter[32] == 1'b1)begin
            carry = 1;
            overflow = 1;
        end
        else begin
            carry = 0;
        end
        if(r == 0)  zero = 1;
        else zero = 0;
    end
    //slt
    else if(control = 2'b0111) begin
        r = (a < b) ? 1 : 0;
    end
    //NOR
    else if(control = 2'b1100) begin
        r = ~(a | b);
        if(r == 0)begin
            zero = 1;
        end
        else begin
            zero = 0;
        end
        overflow = 0;
        carry = 0;
    end
end
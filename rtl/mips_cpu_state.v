module mips_cpu_state(
    input logic clk;
    input logic extra;
    output logic fetch;
    output logic exec1;
    output logic exec2;
);

localparam _exec1 = 2'b001;
localparam _fetch = 2'b000;
localparam _exec2 = 2'b010;
logic[2:0] states_next;
logic[2:0] current;

always@(posedge clock) begin
     current <= states_next;
end

always@(*)begin
    states_next = current;
    case(current)begin
        _fetch: begin
            states_next = _exec1;
            fetch = _fetch;
        end
        _exec1: begin
            if(extra == 1) states_next = _exec2;
            else states_next = _fetch;
            exec1 = _exec1;
        end
        _exec2: begin
            states_next = _fetch;
            exec2 = _exec2;
        end
    end
end

endmodule
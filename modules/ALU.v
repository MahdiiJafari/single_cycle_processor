
module ALU (
    input  [15:0] In1,
    input  [15:0] In2,
    input  [2:0]  Operation,
    output reg [15:0] Result
);

    always @(*) begin
        case(Operation)
            3'b000: Result = In1 + In2;
            3'b001: Result = In1 - In2;
            3'b010: Result = In1 & In2;
            3'b011: Result = In1 | In2;
            3'b100: Result = ~In1;
            3'b101: Result = In1;
            3'b110: Result = In2;
            default: Result = 16'b0;
        endcase
    end

endmodule
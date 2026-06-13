module Instruction_Memory(
    input  [11:0] Address,
    output [15:0] Instruction
);

    reg [15:0] mem [0:4095];

    assign Instruction = mem[Address];

    initial begin
        $readmemh("program.hex", mem);
        $display("Instruction Memory: program.hex loaded successfully.");
    end
endmodule
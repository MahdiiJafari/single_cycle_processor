module Data_Memory(
    input              clk,
    input              MemWrite,
    input              MemRead,
    input      [11:0]  Address,
    input      [15:0]  WriteData,
    output reg [15:0]  ReadData
);

    reg [15:0] mem [0:4095];

    always @(*) begin
        if(MemRead)
            ReadData = mem[Address];
        else
            ReadData = 16'b0;
    end

    always @(posedge clk) begin
        if(MemWrite)
            mem[Address] <= WriteData;
    end

endmodule
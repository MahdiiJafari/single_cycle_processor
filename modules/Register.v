module Register_File (
    input              clk,
    input              rst,
    input      [2:0]   ReadReg1,   
    input      [2:0]   ReadReg2,  
    input      [2:0]   WriteReg,
    input      [15:0]  WriteData,
    input              RegWrite,
    output reg [15:0]  ReadData1,
    output reg [15:0]  ReadData2
);

    reg [15:0] regs [0:7]; 

    always @(*) begin
        ReadData1 = regs[ReadReg1];
        ReadData2 = regs[ReadReg2];
    end

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                regs[i] <= 16'b0;
        end
        else if (RegWrite) begin
            regs[WriteReg] <= WriteData;
        end
    end

endmodule
module PC (
    input              clk,
    input              rst,
    input      [15:0]  NextPC,
    output reg [15:0]  CurrentPC
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            CurrentPC <= 16'b0;
        else
            CurrentPC <= NextPC;
    end
endmodule

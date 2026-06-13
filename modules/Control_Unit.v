module Control_Unit(
    input [3:0] Opcode,
    input [8:0] Func,
    input [2:0] Ri,           // اضافه شد
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Jump,
    output reg Branch,
    output reg ALUSrc,
    output reg MemToReg,
    output reg [2:0] ALUOp,
    output reg [2:0] WriteRegSel  // جدید: انتخاب رجیستر مقصد
);

always @(*) begin
    RegWrite = 0;
    MemRead = 0;
    MemWrite = 0;
    Jump = 0;
    Branch = 0;
    ALUSrc = 0;
    MemToReg = 0;
    ALUOp = 3'b000;
    WriteRegSel = 3'b000;   

    case(Opcode)
        4'b0000: begin // LOAD
            MemRead = 1; RegWrite = 1; MemToReg = 1; WriteRegSel = 3'b000;
        end
        4'b0001: begin // STORE
            MemWrite = 1;
        end
        4'b0010: begin // JUMP
            Jump = 1;
        end
        4'b0100: begin // BRANCHZ
            Branch = 1;
        end
        4'b1000: begin // TYPE C
            case(Func)
                9'b000000001: begin // MoveTo
                    RegWrite = 1; ALUOp = 3'b101; WriteRegSel = Ri;
                end
                9'b000000010: begin // MoveFrom
                    RegWrite = 1; ALUOp = 3'b110; WriteRegSel = 3'b000;
                end
                9'b000000100: begin // Add
                    RegWrite = 1; ALUOp = 3'b000; WriteRegSel = 3'b000;
                end
                9'b000001000: begin // Sub
                    RegWrite = 1; ALUOp = 3'b001; WriteRegSel = 3'b000;
                end
                9'b000010000: begin // And
                    RegWrite = 1; ALUOp = 3'b010; WriteRegSel = 3'b000;
                end
                9'b000100000: begin // Or
                    RegWrite = 1; ALUOp = 3'b011; WriteRegSel = 3'b000;
                end
                9'b001000000: begin // Not
                    RegWrite = 1; ALUOp = 3'b100; WriteRegSel = 3'b000;
                end
                9'b010000000: begin // Nop
                end
                default: begin
                end
            endcase
        end
        4'b1100: begin // ADDI
            RegWrite = 1; ALUSrc = 1; ALUOp = 3'b000; WriteRegSel = 3'b000;
        end
        4'b1101: begin // SUBI
            RegWrite = 1; ALUSrc = 1; ALUOp = 3'b001; WriteRegSel = 3'b000;
        end
        4'b1110: begin // ANDI
            RegWrite = 1; ALUSrc = 1; ALUOp = 3'b010; WriteRegSel = 3'b000;
        end
        4'b1111: begin // ORI
            RegWrite = 1; ALUSrc = 1; ALUOp = 3'b011; WriteRegSel = 3'b000;
        end
        default: begin
        end
    endcase

end
endmodule
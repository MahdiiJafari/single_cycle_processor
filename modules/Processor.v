module Processor(
    input clk,
    input rst
);

    // PC
    wire [15:0] CurrentPC;
    wire [15:0] NextPC;

    PC pc_inst(
        .clk(clk),
        .rst(rst),
        .NextPC(NextPC),
        .CurrentPC(CurrentPC)
    );

    // Instruction Memoryinst_mem
    wire [15:0] Instruction;
    Instruction_Memory inst_mem(
        .Address(CurrentPC[11:0]),
        .Instruction(Instruction)
    );

    // Instruction Fields
    wire [3:0]  Opcode;
    wire [2:0]  Ri;
    wire [11:0] Addr12;
    wire [8:0]  Addr9;
    wire [11:0] Imm12;
    wire [8:0]  Func;

    assign Opcode = Instruction[15:12];
    assign Ri     = Instruction[11:9];
    assign Addr12 = Instruction[11:0];
    assign Addr9  = Instruction[8:0];
    assign Imm12  = Instruction[11:0];
    assign Func   = Instruction[8:0];

    // Control Unit
    wire RegWrite, MemRead, MemWrite, Jump, Branch, ALUSrc, MemToReg;
    wire [2:0] ALUOp;
    wire [2:0] WriteRegSel;          // ← تعریف شد
    wire [15:0] BranchAddr_temp;     // ← تعریف شد

    Control_Unit CU(
        .Opcode(Opcode),
        .Func(Func),
        .Ri(Ri),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Jump(Jump),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .ALUOp(ALUOp),
        .WriteRegSel(WriteRegSel)
    );

    // Register File
    wire [15:0] R0_Data, Ri_Data, WriteBack;
    wire [2:0] WriteReg;          

    assign WriteReg = WriteRegSel;

    Register_File RF(             
        .clk(clk),
        .rst(rst),
        .ReadReg1(3'b000), 
        .ReadReg2(Ri), 
        .WriteReg(WriteReg),      
        .WriteData(WriteBack),
        .RegWrite(RegWrite),
        .ReadData1(R0_Data),
        .ReadData2(Ri_Data)
    );

    // Immediate Extension
    wire [15:0] Imm16;
    SignExtend_12to16 SE12(
        .in(Imm12),
        .out(Imm16)
    );

    // ALU Source MUX
    wire [15:0] ALU_In2;
    Mux2to1 #(16) ALUSrcMUX(
        .in0(Ri_Data),
        .in1(Imm16),
        .sel(ALUSrc),
        .out(ALU_In2)
    );

    // ALU
    wire [15:0] ALU_Result;
    ALU alu_inst(
        .In1(R0_Data),
        .In2(ALU_In2),
        .Operation(ALUOp),
        .Result(ALU_Result)
    );

    // Data Memory
    wire [15:0] MemData;
    Data_Memory DM(
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(Addr12),
        .WriteData(R0_Data),
        .ReadData(MemData)
    );

    // Write Back MUX
    Mux2to1 #(16) WBMUX(
        .in0(ALU_Result),
        .in1(MemData),
        .sel(MemToReg),
        .out(WriteBack)
    );

    wire BranchTaken;
    assign BranchTaken = Branch && (R0_Data == Ri_Data);

    wire [15:0] BranchAddr;
    assign BranchAddr = {CurrentPC[15:9], Addr9}; 
    
    wire [15:0] JumpAddr;
    SignExtend_12to16 SE12_Jump(
        .in(Addr12),
        .out(JumpAddr) 
    );

    assign NextPC = Jump        ? JumpAddr :
                    BranchTaken ? BranchAddr :
                    (CurrentPC + 16'd1);
endmodule

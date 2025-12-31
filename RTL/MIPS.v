module MIPS #(parameter width = 32) (
    input wire clk,
    input wire rst_n,
    // Removed Instr and ReadData as inputs - they are now internal signals

    output wire [width-1 : 0] ALUOut,
    output wire [width-1 : 0] WriteData,
    output wire [width-1 : 0] PC,
    output wire MemWriteM  // Memory stage MemWrite signal (actual memory write enable)
);

wire       zero;
wire       Jump;
wire       RegWrite;
wire       RegDst;
wire       ALUSrc;
wire       MemWrite;
wire       MemtoReg;
wire       PCSrc;
wire       Branch;
wire [2:0] ALUControl;

// Internal signal for instruction (from decode stage)
wire [width-1 : 0] Instr;

Datapath #(.width(width)) inst_Datapath (
    .clk(clk),
    .rst_n(rst_n),
    
    .ALUControl(ALUControl),
    .PCSrc(PCSrc),
    .MemtoReg(MemtoReg),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .Jump(Jump),
    .MemWrite(MemWrite),
    .Branch(Branch),

    .zero(zero),
    .ALUResult(ALUOut),
    .WriteData(WriteData),
    .PC(PC),
    .Instr(Instr),  // Get InstrD from Datapath for Control Unit
    .MemWriteM(MemWriteM)  // Get MemWriteM from Memory stage
);

Control_Unit inst_Control_Unit (
    .Opcode(Instr[31:26]),
    .Funct(Instr[5:0]),
    .zero(zero),

    .Jump(Jump),
    .MemWrite(MemWrite),
    .RegWrite(RegWrite),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .PCSrc(PCSrc),
    .Branch(Branch),
    .ALUControl(ALUControl)
);



endmodule
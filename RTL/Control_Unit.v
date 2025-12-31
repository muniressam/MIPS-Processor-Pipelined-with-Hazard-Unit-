 module Control_Unit (
    input wire [5:0] Opcode,
    input wire [5:0] Funct,
    input wire       zero,

    output wire       Jump,
    output wire       MemWrite,
    output wire       RegWrite,
    output wire       RegDst,
    output wire       ALUSrc,
    output wire       MemtoReg,
    output wire       PCSrc,
    output wire       Branch,
    output wire [2:0] ALUControl

 );


wire [1:0] ALUOP;

Main_Decoder inst_Main_Decoder (
    .Opcode  (Opcode),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUSrc(ALUSrc),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .Jump(Jump),
    .ALUOP(ALUOP)
);

ALU_Decoder inst_ALU_Decoder (
    .Funct(Funct),
    .ALUOP(ALUOP),
    .ALUControl(ALUControl)
);


assign PCSrc = Branch & zero;

    
 endmodule
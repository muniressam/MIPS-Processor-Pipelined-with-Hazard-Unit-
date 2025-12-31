module Datapath #(parameter width = 32) (
    input  wire                 clk,
    input  wire                 rst_n,

    input  wire [2:0]           ALUControl,
    input  wire                 PCSrc,
    input  wire                 MemtoReg,
    input  wire                 ALUSrc,
    input  wire                 RegDst,
    input  wire                 RegWrite,
    input  wire                 Branch,
    input  wire                 Jump,
    input  wire                 MemWrite,  

    output wire                 zero,
    output wire [width-1 : 0]   ALUResult,
    output wire [width-1 : 0]   WriteData,
    output wire [width-1 : 0]   PC,
    output wire [width-1 : 0]   Instr,  
    output wire                 MemWriteM  
);

// Internal wires
wire [width-1 : 0] PCPlus4D;
wire [width-1 : 0] InstrD;
wire [width-1 : 0] RD1D, RD2D;
wire [width-1 : 0] SignImmD;
wire [4:0]         RsD, RtD, RdD;
wire               EqualID;
wire               RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD;
wire [2:0]         ALUControlD;

// Execute stage wires
wire [width-1 : 0] RD1E, RD2E, SignImmE;
wire [4:0]         RsE, RtE, RdE;
wire               RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE;
wire [2:0]         ALUControlE;

// Memory stage wires
wire [width-1 : 0] ALUOutM, WriteDataM, ReadDataM;
wire [4:0]         WriteRegM;
wire               RegWriteM, MemtoRegM;
wire               MemWriteM_int;  

// Writeback stage wires
wire [width-1 : 0] ALUOutW, ResultW;
wire [4:0]         WriteRegW;
wire               RegWriteW, MemtoRegW;

// Hazard/Forwarding wires
wire               ForwardAD, ForwardBD;
wire [1:0]         ForwardAE, ForwardBE;
wire               stallF, stallD, flushE;
wire [4:0]         WriteRegE;  

// Branch calculation wire
wire [width-1 : 0] PCBranch;

// PC wire from Fetch
wire [width-1 : 0] PC_current;

// ------------------------------------------------------------
// Fetch Stage
// ------------------------------------------------------------
Fetch #(width) fetch (
    .EN(!stallF),  // Enable when NOT stalling
    .CLR(stallD),
    .clk(clk),
    .rst_n(rst_n),
    .Jump(Jump),
    .PCSrcD(PCSrc),  
    .PCBranch(PCBranch),
    .InstrD(InstrD),
    .PCPlus4D(PCPlus4D),
    .PC_out(PC_current)
);
// ------------------------------------------------------------
// Decode Stage
// ------------------------------------------------------------
Decode #(width) decode (
    .CLR(flushE),
    .rst_n(rst_n),
    .clk(clk), 
    .InstrD(InstrD),
    .PCPlus4D(PCPlus4D),
    .ForwardAD(ForwardAD),
    .ForwardBD(ForwardBD),
    .ALUOutM(ALUOutM),
    .WriteRegW(WriteRegW),
    .ResultW(ResultW),
    .RegWriteW(RegWriteW),
    
    // Control signals from control unit
    .RegWriteD(RegWrite),
    .MemtoRegD(MemtoReg),
    .MemWriteD(MemWrite),  
    .ALUControlD(ALUControl),
    .ALUSrcD(ALUSrc),
    .RegDstD(RegDst),
    .BranchD(Branch),
    
    // Control signals to execute stage
    .RegWriteE(RegWriteE),
    .MemtoRegE(MemtoRegE),
    .MemWriteE(MemWriteE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .RegDstE(RegDstE),
    
    // Data outputs
    .RD1(RD1D),
    .RD2(RD2D),
    .RsE(RsE),
    .RtE(RtE),
    .RdE(RdE),
    .SignImmE(SignImmE),
    .EqualID(EqualID),
    .PCBranchD(PCBranch)
);

// ------------------------------------------------------------
// Execute Stage
// ------------------------------------------------------------
Execute #(width) execute (
    .clk(clk),
    .rst_n(rst_n),
    .RD1(RD1D),
    .RD2(RD2D),
    .RtE(RtE),
    .RdE(RdE),
    .SignImmE(SignImmE),
    .ResultW(ResultW),
    .ALUOutM_forward(ALUOutM),  

    // Control inputs from decode
    .RegWriteE(RegWriteE),
    .MemtoRegE(MemtoRegE),
    .MemWriteE(MemWriteE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .RegDstE(RegDstE),

    .ForwardAE(ForwardAE),  
    .ForwardBE(ForwardBE),  

    // Outputs to memory stage
    .ALUOutM(ALUOutM),
    .WriteDataM(WriteDataM),
    .WriteRegM(WriteRegM),
    .WriteRegE(WriteRegE),  
    
    // Control outputs to memory stage
    .RegWriteM(RegWriteM),
    .MemtoRegM(MemtoRegM),
    .MemWriteM(MemWriteM_int)
);

// ------------------------------------------------------------
// Memory Stage
// ------------------------------------------------------------
Memory #(width) memory (
    .clk(clk),
    .rst_n(rst_n),
    .ALUOutM(ALUOutM),
    .WriteDataM(WriteDataM),
    .WriteRegM(WriteRegM),
    
    // Control inputs from execute
    .RegWriteM(RegWriteM),
    .MemtoRegM(MemtoRegM),
    .MemWriteM(MemWriteM_int),
    
    // Outputs
    .ReadDataM(ReadDataM),
    .ALUOutW(ALUOutW),
    .WriteRegW(WriteRegW),
    .RegWriteW(RegWriteW),
    .MemtoRegW(MemtoRegW)
);

// ------------------------------------------------------------
// Writeback Stage
// ------------------------------------------------------------
Writeback #(width) writeback (
    .ReadDataW(ReadDataM),
    .ALUOutW(ALUOutW),
    .MemtoRegW(MemtoRegW),
    .ResultW(ResultW)
);

// ------------------------------------------------------------
// Hazard Unit
// ------------------------------------------------------------

Hazard_Unit hazard_unit (
    .RSD(InstrD[25:21]),
    .RTD(InstrD[20:16]),
    .RSE(RsE),
    .RTE(RtE),
    .memToRegE(MemtoRegE),
    .regWriteE(RegWriteE),  
    .regWriteM(RegWriteM),
    .regWriteW(RegWriteW),
    .writeRegE(WriteRegE),  
    .writeRegM(WriteRegM),
    .writeRegW(WriteRegW),

    .stallF(stallF),  
    .stallD(stallD),  
    .forwardAD(ForwardAD),
    .forwardBD(ForwardBD),
    .flushE(flushE),  
    .forwardAE(ForwardAE),
    .forwardBE(ForwardBE)
);
// ------------------------------------------------------------
// Output Assignments
// ------------------------------------------------------------
assign ALUResult = ALUOutM;
assign WriteData = WriteDataM;
assign zero = EqualID;
assign PC = PC_current;  
assign Instr = InstrD;   
assign MemWriteM = MemWriteM_int;

endmodule
module Decode #(parameter width = 32)(
    input wire                CLR,
    input wire                rst_n,
    input wire                clk,
    input wire [width-1 : 0 ] InstrD,
    input wire [width-1 : 0 ] PCPlus4D,
    input wire                ForwardAD,
    input wire                ForwardBD,
    input wire [width-1 : 0 ] ALUOutM,
    input wire [4 : 0 ]       WriteRegW,
    input wire [width-1 : 0 ] ResultW,
    input wire                RegWriteW,

    // inputs from control unit
    input wire               RegWriteD,
    input wire               MemtoRegD,
    input wire               MemWriteD,
    input wire               [2:0] ALUControlD,
    input wire               ALUSrcD,
    input wire               RegDstD,
    input wire               BranchD,

    // OUTPUTS from control unit
    output reg               RegWriteE,
    output reg               MemtoRegE,
    output reg               MemWriteE,
    output reg               [2:0] ALUControlE,
    output reg               ALUSrcE,
    output reg               RegDstE,

    output reg [width-1 : 0] RD1,
    output reg [width-1 : 0] RD2,
    output reg [4:0]         RsE, 
    output reg [4:0]         RtE, 
    output reg [4:0]         RdE, 
    output reg [width-1 : 0] SignImmE,
    output wire              EqualID ,
    output wire [width-1 : 0] PCBranchD
);

wire [width-1 : 0] rd1;
wire [width-1 : 0] rd2;
wire [width-1 : 0] Equal_forwardAD;
wire [width-1 : 0] Equal_forwardBD;

assign Equal_forwardAD = (ForwardAD) ? ALUOutM : rd1;
assign Equal_forwardBD = (ForwardBD) ? ALUOutM : rd2;
assign EqualID = (Equal_forwardAD == Equal_forwardBD);

wire [4:0] RsD;
wire [4:0] RtD; 
wire [4:0] RdD; 

assign RsD = InstrD[25:21];
assign RtD = InstrD[20:16];
assign RdD = InstrD[15:11];

wire [width-1 : 0] SignImmD;

Register_File inst_Register_File(
    .clk  (clk),
    .rst_n(rst_n),
    .WE3  (RegWriteW),
    .A1   (InstrD[25:21]),
    .A2   (InstrD[20:16]),
    .A3   (WriteRegW),
    .WD3  (ResultW),
    .RD1  (rd1), 
    .RD2  (rd2)
);

Sign_Extend inst_Sign_Extend (
    .Instr  (InstrD),
    .SignImm(SignImmD)
);

PCBranch inst_PCBranch (
    .SignImm (SignImmD),
    .PCPlus4 (PCPlus4D),
    .PCBranch(PCBranchD)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || CLR) begin
        RD1<= 0;
        RD2<= 0;
        RsE<= 0; 
        RtE<= 0; 
        RdE<= 0; 
        SignImmE<= 0;
    end else begin
        RD1<= rd1;
        RD2<= rd2;
        RsE<= RsD; 
        RtE<= RtD; 
        RdE<= RdD; 
        SignImmE<= SignImmD;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || CLR) begin
        RegWriteE <= 0;
        MemtoRegE <= 0;
        MemWriteE <= 0;
        ALUControlE <= 0;
        ALUSrcE   <= 0;
        RegDstE   <= 0;
    end else begin
        RegWriteE <= RegWriteD;
        MemtoRegE <= MemtoRegD;
        MemWriteE <= MemWriteD;
        ALUControlE <= ALUControlD;
        ALUSrcE   <= ALUSrcD;
        RegDstE   <= RegDstD;
    end
end
endmodule
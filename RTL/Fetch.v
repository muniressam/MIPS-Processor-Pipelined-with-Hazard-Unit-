module Fetch #(parameter width = 32)(
    input  wire                 EN,
    input  wire                 CLR,
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 Jump,
    input  wire                 PCSrcD,
    input  wire [width-1 : 0]   PCBranch,

    output reg [width-1 : 0]   InstrD,
    output reg [width-1 : 0]   PCPlus4D,
    output wire [width-1 : 0]  PC_out
);

wire [width-1 : 0] PCF;
wire [width-1 : 0] InstrF;
wire [width-1 : 0] PCPlus4F;

Instrustion_Memory inst_inst_memory(
    .PC(PCF),
    .clk(clk),
    .Instr(InstrF)  
);

PC_MUX_flip inst_pc_mux_flip(
    .clk(clk),
    .rst_n(rst_n),
    .Jump(Jump),
    .PCSrc(PCSrcD),
    .PCBranch(PCBranch),
    .PCPlus4(PCPlus4F),
    .Instr(InstrD), 
    .PC(PCF)
);

PCPlus4 inst_pcplus4 (
    .PC(PCF),
    .PCPlus4(PCPlus4F)
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || CLR) begin
        InstrD <= 0;
        PCPlus4D <= 0;
    end
    else if (EN == 1'b1) begin
        InstrD <= InstrF;
        PCPlus4D <= PCPlus4F;
    end
end

assign PC_out = PCF;

endmodule
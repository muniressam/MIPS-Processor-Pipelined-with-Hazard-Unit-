module Execute #(parameter width = 32)(
    input wire               clk,
    input wire               rst_n,
    input wire [width-1 : 0] RD1,
    input wire [width-1 : 0] RD2,
    input wire [4:0]         RtE, 
    input wire [4:0]         RdE, 
    input wire [width-1 : 0] SignImmE,
    input wire [width-1 : 0] ResultW,
    input wire [width-1 : 0] ALUOutM_forward,  

    // inputs from control unit
    input wire               RegWriteE,
    input wire               MemtoRegE,
    input wire               MemWriteE,
    input wire               [2:0] ALUControlE,
    input wire               ALUSrcE,
    input wire               RegDstE,

    // inputs from hazard unit
    input wire [1:0]         ForwardAE,
    input wire [1:0]         ForwardBE,

    output wire [width-1 : 0] ALUOutM,
    output reg [width-1 : 0] WriteDataM,
    output reg [4:0]         WriteRegM,
    output wire [4:0]        WriteRegE,

    output reg               RegWriteM,
    output reg               MemtoRegM,
    output reg               MemWriteM
);

assign WriteRegE = (RegDstE) ? RdE : RtE;


reg  [width-1 : 0] SrcAE;
wire [width-1 : 0] SrcBE;
wire [width-1 : 0] ALUResult;
reg  [width-1 : 0] WriteDataE;
reg  [width-1 : 0] ALUOutM_int;


always @(*) begin
    case(ForwardAE) 
        2'b00 : SrcAE = RD1;
        2'b01 : SrcAE = ResultW;      
        2'b10 : SrcAE = ALUOutM_forward; 
        default: SrcAE = RD1;
    endcase
end
always @(*) begin
    case(ForwardBE)
        2'b00 : WriteDataE = RD2;
        2'b01 : WriteDataE = ResultW;  
        2'b10 : WriteDataE = ALUOutM_forward;  
        default: WriteDataE = RD2;
    endcase
end

MUX inst_MUX_ALU (
    .SEL(ALUSrcE),
    .IN1(WriteDataE),
    .IN2(SignImmE),
    .OUT(SrcBE)
);

ALU inst_ALU (
    .ALUControl(ALUControlE),
    .SrcA      (SrcAE),
    .SrcB      (SrcBE),
    .zero      (),
    .ALUResult (ALUResult)
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ALUOutM_int <= 0;
        WriteDataM <= 0;
        WriteRegM  <= 0;
    end else begin
        ALUOutM_int <= ALUResult;
        WriteDataM <= WriteDataE;
        WriteRegM  <= WriteRegE;
    end
end

assign ALUOutM = ALUOutM_int;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        RegWriteM  <= 0;
        MemtoRegM  <= 0;
        MemWriteM  <= 0;
    end else begin
        RegWriteM  <= RegWriteE;
        MemtoRegM  <= MemtoRegE;
        MemWriteM  <= MemWriteE;
    end
    
end
    
endmodule
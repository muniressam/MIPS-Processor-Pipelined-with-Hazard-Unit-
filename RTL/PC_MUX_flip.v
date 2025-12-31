module PC_MUX_flip #(parameter width = 32) (
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 Jump,
    input  wire                 PCSrc,
    input  wire [width-1 : 0]   PCBranch,
    input  wire [width-1 : 0]   PCPlus4,
    input  wire [width-1 : 0]   Instr,

    output reg  [width-1 : 0]   PC
);

wire [width-1 : 0] PC_reg;

assign PC_reg = (PCSrc == 1'b1) ? PCBranch : PCPlus4;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        PC <= {width{1'b0}};
    end else if (Jump == 1'b1) begin
        PC <= {PCPlus4[31:28], Instr[25:0], 2'b00};
    end else begin
        PC <= PC_reg;
    end
end



    
endmodule
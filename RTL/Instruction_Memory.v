module Instrustion_Memory #(parameter width = 32) (
    input wire [width-1 : 0] PC,
    input wire clk,
    output reg [width-1 : 0] Instr
);

reg [width-1 : 0] ROM [0: 255];

always @(posedge clk) begin
    Instr = ROM[PC[9:2]];
end

initial begin
    $readmemh("MIPS_inst.txt",ROM);
end

endmodule
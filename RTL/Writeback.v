module Writeback #(parameter width = 32) (
    input wire [width-1 : 0] ReadDataW,
    input wire [width-1 : 0] ALUOutW,
    input wire               MemtoRegW,

    output wire [width-1 : 0] ResultW
);

assign ResultW = (MemtoRegW) ? ReadDataW : ALUOutW;

endmodule
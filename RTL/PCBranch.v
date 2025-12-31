module PCBranch #(parameter width = 32)(
    input wire [width-1 : 0] SignImm,
    input wire [width-1 : 0] PCPlus4,
    output wire [width-1 : 0] PCBranch
);
    
assign PCBranch = (SignImm << 2) + PCPlus4;

endmodule
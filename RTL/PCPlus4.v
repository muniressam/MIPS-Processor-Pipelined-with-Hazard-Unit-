module PCPlus4 #(parameter width = 32) (
    input wire [width-1 : 0 ] PC,

    output wire [width-1 : 0] PCPlus4
);

assign PCPlus4 = PC + 32'd4 ;

endmodule
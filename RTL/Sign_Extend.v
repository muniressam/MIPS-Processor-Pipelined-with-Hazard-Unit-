module Sign_Extend #(parameter width = 32)(
    input wire [width-1 : 0 ] Instr,
    output wire [width-1 : 0 ] SignImm
); 

assign SignImm = {{16{Instr[width/2-1]}}, Instr[width/2-1:0]};
    
endmodule
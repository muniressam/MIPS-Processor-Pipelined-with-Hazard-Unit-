`timescale 1ns/1ps

module MIPS_TB #(parameter width = 32) (
);
    reg clk;
    reg rst_n;

    // Removed Instr and ReadData - they are now internal to MIPS module
    wire [width-1 : 0] ALUOut;
    wire [width-1 : 0] WriteData;
    wire [width-1 : 0] PC;
    

    localparam clk_period = 5 ;

    MIPS DUT (
        .clk      (clk),
        .rst_n    (rst_n),
        // Removed .Instr and .ReadData - they are now internal signals
        .ALUOut   (ALUOut),
        .WriteData(WriteData),
        .PC       (PC)
    );

always #(clk_period / 2)  clk = ~clk;

initial begin
    clk = 0;
end
initial begin
    $dumpfile("MIPS_TB.vcd");
    $dumpvars(0, MIPS_TB);
    rst_n = 0;
    @(negedge clk) ;
    rst_n = 1;
    repeat (100)  @(negedge clk);
    $stop;
    
end
endmodule


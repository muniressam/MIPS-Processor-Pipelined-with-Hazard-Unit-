module Hazard_Unit (
    input wire [4:0] RSD,
    input wire [4:0] RTD,
    input wire [4:0] RSE,
    input wire [4:0] RTE,
    input wire       memToRegE,
    input wire       regWriteE,
    input wire       regWriteM,
    input wire       regWriteW,
    input wire [4:0] writeRegE,
    input wire [4:0] writeRegM,
    input wire [4:0] writeRegW,

    output reg        stallF,
    output reg        stallD,
    output reg        forwardAD,
    output reg        forwardBD,
    output reg        flushE,
    output reg [1:0]  forwardAE,
    output reg [1:0]  forwardBE
);

always @(*) begin
    stallF = ((RSD == writeRegE) || (RTD == writeRegE)) && memToRegE && regWriteE;
    stallD = stallF;
    flushE = stallF;

    forwardAD = (RSD != 0) && (RSD == writeRegM) && regWriteM;
    forwardBD = (RTD != 0) && (RTD == writeRegM) && regWriteM;

    if ((RSE != 0) && (RSE == writeRegM) && regWriteM)
        forwardAE = 2'b10;  
    else if ((RSE != 0) && (RSE == writeRegW) && regWriteW)
        forwardAE = 2'b01; 
    else 
        forwardAE = 2'b00;  

   
    if ((RTE != 0) && (RTE == writeRegM) && regWriteM)
        forwardBE = 2'b10;  
    else if ((RTE != 0) && (RTE == writeRegW) && regWriteW)
        forwardBE = 2'b01;  
    else 
        forwardBE = 2'b00;  
end

endmodule 
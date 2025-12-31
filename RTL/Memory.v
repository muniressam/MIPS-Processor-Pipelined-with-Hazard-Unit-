module Memory #(parameter width = 32) (
    input wire clk,
    input wire rst_n,
    input wire [width-1 : 0] ALUOutM,
    input wire [width-1 : 0] WriteDataM, 
    input wire [4 : 0]       WriteRegM, 

    // inputs from control unit
    input wire RegWriteM,
    input wire MemtoRegM,
    input wire MemWriteM,

    output reg [width-1 : 0] ReadDataM,
    output reg [width-1 : 0] ALUOutW,
    output reg [4 : 0]       WriteRegW,

    output reg RegWriteW,
    output reg MemtoRegW
);

wire [width-1 : 0] ReadData;

Data_Memory inst_Data_Memory (
        .clk      (clk),
        .rst_n    (rst_n),
        .WE       (MemWriteM),
        .Address  (ALUOutM),
        .WriteData(WriteDataM),
        .ReadData (ReadData)
    );


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ReadDataM <=0;
        ALUOutW   <=0;
        WriteRegW <=0;
    end else begin
        ReadDataM <= ReadData;
        ALUOutW   <= ALUOutM;
        WriteRegW <= WriteRegM;
    end
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        RegWriteW  <= 0;
        MemtoRegW  <= 0;
    end else begin
        RegWriteW  <= RegWriteM;
        MemtoRegW  <= MemtoRegM;
    end
    
    
end 
endmodule
module Register_File #(parameter width = 32) (
    input wire               clk,
    input wire               rst_n,
    input wire               WE3,
    input wire [4:0]         A1,
    input wire [4:0]         A2,
    input wire [4:0]         A3,
    input wire [width-1 : 0] WD3,
    output reg [width-1 : 0] RD1,
    output reg [width-1 : 0] RD2

);
reg [width-1 : 0 ] REG_MEM [0 : width-1] ;
integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
         for (i = 0; i <width ; i=i+1 ) begin
                REG_MEM [i] <= 32'b0;
            end
    end
    else begin
        if(WE3) begin
            REG_MEM[A3] = WD3;
        end
    end
end 
always @(*) begin
    RD1 = REG_MEM[A1];
    RD2 = REG_MEM[A2];
end   
endmodule
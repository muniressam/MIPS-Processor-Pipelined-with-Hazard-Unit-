module ALU_Decoder (
    input wire [5:0] Funct,
    input wire [1:0] ALUOP,
 
    output reg [2:0] ALUControl
);

localparam  add = 6'b100000,
            sub = 6'b100010,
            and_= 6'b100100,
            or_ = 6'b100101,
            slt = 6'b101010;
    
always @(*) begin
    if(ALUOP == 2'b00) begin
        ALUControl = 3'b010;
    end
    else if (ALUOP[0] == 1'b1 ) begin
        ALUControl = 3'b110;
    end
    else begin
        case (Funct)
            add : ALUControl = 3'b010;
            sub : ALUControl = 3'b110;
            and_: ALUControl = 3'b000;
            or_ : ALUControl = 3'b001;
            slt : ALUControl = 3'b111;
            default: ALUControl = 3'b000;
        endcase
    end
    
end
endmodule
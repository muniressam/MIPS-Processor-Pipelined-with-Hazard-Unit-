module ALU #(parameter width = 32)(
    input wire [width-1 : 0] SrcA,
    input wire [width-1 : 0] SrcB,
    input wire [2:0]         ALUControl,

    output wire              zero,
    output reg [width-1 : 0] ALUResult

);

localparam  add = 3'b010,
            sub = 3'b110,
            and_= 3'b000,
            or_ = 3'b001,
            
            slt = 3'b111;

always @(*) begin
    case (ALUControl)
        add : ALUResult = SrcA + SrcB;
        sub : ALUResult = SrcA - SrcB;
        and_: ALUResult = SrcA & SrcB;
        or_ : ALUResult = SrcA | SrcB;
        slt : ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0 ; 
        default: ALUResult = 32'b0;
    endcase
end

assign zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

    
endmodule
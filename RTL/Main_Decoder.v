module Main_Decoder (
    input wire [5:0] Opcode,

    output reg       MemtoReg,
    output reg       MemWrite,
    output reg       Branch,
    output reg       ALUSrc,
    output reg       RegDst,
    output reg       RegWrite,
    output reg       Jump,
    output reg [1:0] ALUOP
);

localparam  R_type = 6'b000000,
            LW     = 6'b100011,
            SW     = 6'b101011,
            beq    = 6'b000100,
            addi   = 6'b001000,
            J      = 6'b000010;

always @(*) begin
    MemtoReg = 0 ;
    MemWrite = 0 ;
    Branch = 0 ;
    ALUSrc = 0 ;
    RegDst = 0 ;
    RegWrite = 0 ;
    Jump = 0 ;
    ALUOP = 2'b00 ;

    case(Opcode) 
        R_type : begin
            RegWrite = 1;
            RegDst   = 1;
            ALUOP    = 2'b10;
        end
        LW : begin
            RegWrite = 1;
            ALUSrc = 1;
            MemtoReg = 1;
        end
        SW  :begin
            ALUSrc = 1;
            MemWrite = 1;
        end
        beq  :begin
            Branch = 1;
            ALUOP = 2'b01;
        end
        addi : begin
            RegWrite = 1;
            ALUSrc = 1;
        end
        J : begin
            Jump = 1;
        end
        
    endcase
end
    
endmodule
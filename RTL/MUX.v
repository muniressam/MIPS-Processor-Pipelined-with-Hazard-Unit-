module MUX #(parameter width = 32) (
    input wire SEL,
    input wire [width-1 : 0] IN1,
    input wire [width-1 : 0] IN2,

    output wire [width-1 : 0] OUT
);

assign OUT = (SEL == 1'b0) ? IN1 : IN2;

endmodule
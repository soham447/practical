`timescale 1ns / 1ps

module ALU(
    input [3:0] a,
    input [3:0] b,
    input [2:0] sel,
    output reg [3:0] result
);

always @(*) begin
    case (sel)
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = ~ a;
        3'b110: result = a << 1;
        3'b111: result = a >> 1;
        default: result = 4'b0000;
    endcase
end
endmodule

/////////////////////////// TB /////////////////////////////////

`timescale 1ns / 1ps

module ALUtb;
reg [3:0] a , b ;
reg [3:0] sel;
wire [3:0] result;
ALU DUT (
    .a(a),
    .b(b),
    .sel(sel),
    .result(result)
);
initial begin
    $monitor("sel=%b a=%b b=%b -> result=%b", sel , a, b, result);
    a = 4'b0011; b = 4'b0001;
    sel = 3'b000; #10
    sel = 3'b001; #10
    sel = 3'b010; #10
    sel = 3'b011; #10
    sel = 3'b100; #10
    sel = 3'b101; #10
    sel = 3'b110; #10
    sel = 3'b111; #10
    $finish;
end
endmodule
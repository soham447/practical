`timescale 1ns / 1ps

module jkff (
    input j, k, clk, rst,
    output reg q,
    output q_bar
);

reg [1:0] counter;
reg clk_div;

// Clock divider with reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        clk_div <= 0;
    end
    else begin
        counter <= counter + 1;
        clk_div <= counter[1];
    end
end

// JK flip-flop logic
assign q_bar = ~q;
always @(posedge clk_div or posedge rst) begin
    if (rst)
        q <= 0;
    else begin
        case ({j,k})
            2'b00: q <= q;
            2'b01: q <= 0;
            2'b10: q <= 1;
            2'b11: q <= ~q;
        endcase
    end
end
endmodule


/////////////////   TB   /////////////////

`timescale 1ns / 1ps
module jkfftb;

reg j, k, clk, rst;
wire q, q_bar;

jkff uut(
    .j(j),
    .k(k), 
    .clk(clk),
    .rst(rst), 
    .q(q), 
    .q_bar(q_bar)
);

// Clock generation
always #10 clk = ~clk;
// Test stimulus
initial begin
    clk = 0;
    j = 0; k = 0;
    rst = 1;
    #100;
    rst = 0;
    j = 0; k = 0; #100; // Hold
    j = 0; k = 1; #100; // Reset
    j = 1; k = 0; #100; // Set
    j = 1; k = 1; #100; // Toggle
    j = 1; k = 1; #100; // Toggle again
    j = 0; k = 0; #100; // Hold
    #1000;
    $finish;
end

initial begin
    $monitor("Time=%0t | rst=%b | J=%b | K=%b | clk=%b | Q=%b |Qbar=%b",
    $time, rst, j, k, clk, q, q_bar);
end
endmodule
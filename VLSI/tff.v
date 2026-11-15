`timescale 1ns / 1ps
module tff (
    input t, clk, rst,
    output reg q,
    output q_bar
);

reg [2:0] counter;
reg clk_div;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        clk_div <= 0;
    end
    else begin
        counter <= counter + 1;
        clk_div <= counter[2];
    end
end

assign q_bar = ~q;
always @(posedge clk_div or posedge rst) begin
    if (rst)
        q <= 0;
    else if (t)
        q <= ~q; // Toggle
    else
        q <= q; // Hold
end
endmodule


////////////////////    TB      /////////////////////////

`timescale 1ns / 1ps
module tfftb;

reg t, clk, rst;
wire q, q_bar;

// Instantiate DUT
tff uut (
    .t(t), 
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
    t = 0;
    rst = 1;
    #200;
    rst = 0;
    t = 0; #200; // Hold
    t = 1; #200; // Toggle
    t = 1; #200; // Toggle again
    t = 0; #200; // Hold
    t = 1; #400; // Toggle
    $finish;
end
initial begin
    $monitor("Time=%0t | rst=%b | T=%b | clk=%b | Q=%b | Qbar=%b",
    $time, rst, t, clk, q, q_bar);
end
endmodule
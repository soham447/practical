module async_counter (
    input wire clk,
    input wire rst,
    output reg [2:0] q
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

// Flip-flop 0
always @(posedge clk_div or posedge rst) begin
    if (rst)
        q[0] <= 1'b0;
    else
        q[0] <= ~q[0];
end

// Flip-flop 1
always @(negedge q[0] or posedge rst) begin
    if (rst)
        q[1] <= 1'b0;
    else
        q[1] <= ~q[1];
end

// Flip-flop 2
always @(negedge q[1] or posedge rst) begin
    if (rst)
        q[2] <= 1'b0;
    else
        q[2] <= ~q[2];
end
endmodule



//////////////////////////  TB /////////////////////////

`timescale 1ns / 1ps

module async_counter_tb;

reg clk,rst;
wire [2:0] q;

// Instantiate the counter
async_counter uut (
    .clk(clk),
    .rst(rst),
    .q(q)
);

// Clock generation: 10 ns period
always #10 clk = ~clk;
initial begin
    // Initialize
    clk = 1'b0;
    rst = 1'b1;
    // Apply reset
    #10;
    rst = 1'b0;
    // Run counter
    #1000;
    $finish;
end

// Display values
initial begin
    $monitor("Time = %0t | Reset = %b | Q = %b", $time, rst, q);
end

endmodule
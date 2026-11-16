//////  JK FF //////////////////

`timescale 1ns / 1ps

module async_counter_3bit (
    input clk,
    input rst,
    output reg [2:0] q
);

// First flip-flop (LSB)
always @(posedge clk or posedge rst) begin
    if (rst)
        q[0] <= 0;
    else
        q[0] <= ~q[0];
end

// Second flip-flop
always @(posedge q[0] or posedge rst) begin
    if (rst)
        q[1] <= 0;
    else
        q[1] <= ~q[1];
end

// Third flip-flop (MSB)
always @(posedge q[1] or posedge rst) begin
    if (rst)
        q[2] <= 0;
    else
        q[2] <= ~q[2];
end

endmodule

//////// TB //////////////

`timescale 1ns / 1ps

module async_counter_3bit_tb;

reg clk, rst;
wire [2:0] q;

async_counter_3bit uut (
    .clk(clk),
    .rst(rst),
    .q(q)
);

// Clock generation
always #10 clk = ~clk;

// Test stimulus
initial begin
    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    #500;

    rst = 1;
    #20;
    rst = 0;

    #200;
    $finish;
end

// Monitor
initial begin
    $monitor("Time=%0t | Reset=%b | CLK=%b | Q=%b",
              $time, rst, clk, q);
end

endmodule


///////// T FF  //////////////////////////////

// T Flip-Flop
module t_ff (
    input t,
    input clk,
    input rst,
    output reg q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 1'b0;
    else if (t)
        q <= ~q;
end

endmodule


// 3-bit Asynchronous Up Counter
module async_counter (
    input clk,
    input rst,
    output [2:0] q
);

    // T Flip-Flop instances
    t_ff ff0 (
        .t(1'b1),
        .clk(clk),
        .rst(rst),
        .q(q[0])
    );

    t_ff ff1 (
        .t(1'b1),
        .clk(q[0]),
        .rst(rst),
        .q(q[1])
    );

    t_ff ff2 (
        .t(1'b1),
        .clk(q[1]),
        .rst(rst),
        .q(q[2])
    );

endmodule

///////////// TB /////////////////

`timescale 1ns / 1ps

module tb_async_counter;

    reg clk;
    reg rst;
    wire [2:0] q;

    // Instantiate DUT
    async_counter uut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin

        // Initialize signals
        clk = 0;
        rst = 1;

        // Apply reset
        #10;
        rst = 0;

        // Monitor output
        $monitor("Time = %0t | Reset = %b | Q2Q1Q0 = %b",
                  $time, rst, q);

        // Generate clock pulses
        #100;

        $finish;
    end

endmodule

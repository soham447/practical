//////  JK FF //////////////////

module jk_ff (
    input j, k, clk, rst,
    output reg q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        q <= 1'b0;
    else
        case ({j,k})
            2'b00: q <= q;
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= ~q;
        endcase
end

endmodule


// 3-bit Asynchronous Counter

module async_counter_3bit (
    input clk,
    input rst,
    output [2:0] q
);

wire j, k;

assign j = 1'b1;
assign k = 1'b1;

// First flip-flop
jk_ff FF0(j, k, clk, rst, q[0]);

// Second flip-flop
jk_ff FF1(j, k, q[0], rst, q[1]);

// Third flip-flop
jk_ff FF2(j, k, q[1], rst, q[2]);

endmodule

//////// TB //////////////

`timescale 1ns/1ps

module tb_async_counter;

reg clk, rst;
wire [2:0] q;

async_counter_3bit uut (
    .clk(clk),
    .rst(rst),
    .q(q)
);

// Clock generation
always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    #10 rst = 0;

    #200;

    $finish;
end

initial begin
    $monitor("Time=%0t | Count=%b", $time, q);
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

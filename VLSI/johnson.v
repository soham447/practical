module johnson #( parameter N = 4)
(
    input wire clk,
    input wire reset,
    output reg [N-1:0] q,
    output wire led_clk
);

// Clock divider for visible LED blinking
reg [26:0] clk_div = 0;
reg slow_clk = 0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        clk_div <= 0;
        slow_clk <= 0;
    end
    else begin
        if (clk_div == 27'd49999999) begin
            clk_div <= 0;
            slow_clk <= ~slow_clk;
        end
        else begin
            clk_div <= clk_div + 1'b1;
        end
    end
end
// N-bit Johnson counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= {N{1'b0}};
    end
    else begin
        q <= {~q[0], q[N-1:1]};
    end
end

assign led_clk = slow_clk;
endmodule

//////////////////////// TB ///////////////////////////////

`timescale 1ns / 1ps

module johnson_tb;

parameter N = 4;
reg clk;
reg reset;
wire [N-1:0] q;
wire led_clk;

// Instantiate the design
johnson #(.N(N)) uut (
    .clk(clk),
    .reset(reset),
    .q(q),
    .led_clk(led_clk)
);
// Generate a 10 ns clock period
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end
// Apply reset and run simulation
initial begin
    reset = 1'b1;
    #15;
    reset = 1'b0;
    // Observe multiple Johnson counter cycles
    #200;
    $finish;
end
// Display counter output
initial begin
    $monitor(
    "Time=%0t ns | Reset=%b | q=%b | led_clk=%b",
    $time, reset, q, led_clk
    );
end
endmodule
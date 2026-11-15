`timescale 1ns/1ps
module siso (
    input clk, rst,
    input si, // serial input
    output so // serial output
);

reg [3:0] shift_reg;
reg [2:0] counter;
reg clk_div;
// Clock divider with reset
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

// Shift register
always @(posedge clk_div or posedge rst) begin
    if (rst)
        shift_reg <= 4'b0000;
    else
        shift_reg <= {shift_reg[2:0], si};
end

assign so = shift_reg[3];
endmodule

///////////////////// TB //////////////////////////////

`timescale 1ns/1ps
module sisotb;

reg clk = 0;
reg rst;
reg si;
wire so;

siso uut (
    .clk(clk), 
    .rst(rst), 
    .si(si), 
    .so(so)
);

always #5 clk = ~clk;
initial begin
    rst = 1;
    si = 0;
    #10 rst = 0;
    // Shift in 1011
    si = 1; #100;
    si = 0; #100;
    si = 1; #100;
    si = 1; #100;
    #1000;
    $finish;
end
endmodule
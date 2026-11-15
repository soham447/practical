module mux4(
    input wire s0, 
    input wire s1, 
    input wire i0, 
    input wire i1, 
    input wire i2, 
    input wire i3, 
    output reg y
);
always @(*) begin 
    case ({s1, s0})
    2'b00 : y = i0;
    2'b01 : y = i1;
    2'b10 : y = i2;
    2'b11 : y = i3;
    default: y = 1'b0;
endcase 
end 
endmodule




//////////////////   testbench  ////////////////////////

module muxtb;
reg s0, s1, i0, i1, i2, i3;
wire y;
mux4 uut(
    s0, s1, i0, i1, i2, i3, y
);
initial begin i0 = 0;
    i1 = 1;
    i2 = 0;
    i3 = 1;
    s1 = 0;
    s0 = 0;
    # 10;
    s1 = 0;
    s0 = 1;
    # 10;
    s1 = 1;
    s0 = 0;
    # 10;
    s1 = 1;
    s0 = 1;
    # 10;
    $finish;
end 
endmodule


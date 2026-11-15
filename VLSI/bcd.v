module bcd(
    input[3:0]bin,
    output[3:0]gray
);

assign gray[3]=bin[3];
xor (gray[2],bin[3],bin[2]);
xor (gray[1],bin[2],bin[1]);
xor (gray[0],bin[1],bin[0]);

endmodule

////////////////////  TB /////////////////////////////

module bcdtb;

reg[3:0]bin;
wire[3:0]gray;

//instantiate the module
bcd uut(
    .bin(bin) ,
    .gray(gray)
);

initial begin
    $display("Bin Gray");
    for(bin=0; bin<16;bin=bin+1)begin
        #10;
        $display("%b %b",bin,gray);
    end
    $finish;
end
endmodule
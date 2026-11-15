module halfadder(     
    input a,     
    input b,     
    output sum,     
    output carry     
);     

assign sum=a^b;     
assign carry=a&b; 

endmodule 


////////////  testbench    ////////////////////////

module halfaddertb; 
reg a,b; 
wire sum,carry; 
halfadder uut(a,b,sum,carry); 

initial begin 
    a=0;
    b=0;        #10; 
    a=0;b=1;    #10; 
    a=1;b=0;    #10; 
    a=1;b=1;    #10; 
    $finish; 
end  
endmodule
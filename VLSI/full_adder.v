// Half Adder 
module HA(     
    input a,     
    input b,     
    output sum,     
    output carry 
);  

assign sum = a ^ b; 
assign carry = a & b;  
endmodule   

// Full Adder 
module FA(     
    input a,     
    input b,     
    input cin,     
    output sum,     
    output cout 
);  

wire sum1; 
wire carry1; 
wire carry2;  
// First Half Adder 
HA HA1(     
    .a(a),     
    .b(b),     
    .sum(sum1),     
    .carry(carry1) 
);  
    
// Second Half Adder 
HA HA2(     
    .a(sum1),     
    .b(cin),     
    .sum(sum),     
    .carry(carry2) 
);  

// Final Carry 

assign cout = carry1 | carry2;  
endmodule



///////////////////  testbench   /////////////////// 

module full_adder_tb; 
reg a, b, cin; 
wire sum, cout; 
FA DUT (     
    .a(a),  
    .b(b),     
    .cin(cin),     
    .sum(sum),     
    .cout(cout) 
);  

initial begin      
    a = 0; 
    b = 0; 
    cin = 0; #10;     
    a = 0; 
    b = 0; 
    cin = 1; #10;     
    a = 0; 
    b = 1; 
    cin = 0; #10;     
    a = 0; 
    b = 1; 
    cin = 1; #10;     
    a = 1; 
    b = 0; 
    cin = 0; #10;     
    a = 1; 
    b = 0; 
    cin = 1; #10;     
    a = 1; 
    b = 1; 
    cin = 0; #10;    
    a = 1; 
    b = 1; 
    cin = 1; #10;      
    $finish;  
end 
endmodule 
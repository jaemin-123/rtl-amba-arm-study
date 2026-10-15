module half_adder_0 (a, b, cout, sum);
    input a, b;
    output cout, sum;
    
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

module half_adder_1 (a, b, cout, sum);
    input a, b;
    output cout, sum;
    
    and (cout, a, b);
    xor (sum, a, b);
endmodule

module half_adder_2 (a, b, cout, sum);
    input a, b;
    output cout, sum;
    
    reg cout, sum;
    
    always @(*) begin
        sum = a ^ b;
        cout = a & b;
    end
endmodule

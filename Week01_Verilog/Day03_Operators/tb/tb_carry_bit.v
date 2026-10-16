module tb_carry_bit ();
    reg [3:0] a, b;
    wire [3:0] sum;
    wire carry;
    
    carry_bit DUT (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );
    
    initial begin
        a = 4'b1111; b = 4'b0001;
        #10 a = 4'b0011; b = 4'b0100;
        #10 a = 4'b1010; b = 4'b1001;
        #10 a = 4'b1111; b = 4'b1111;
        #10 $finish;
    end
endmodule

module tb_adder4 ();
    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire cout;
    
    adder4 U1 (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    initial begin
        a = 4'd0;  b = 4'd0;  cin = 0;
        #10 a = 4'd3;  b = 4'd4;  cin = 0;
        #10 a = 4'd7;  b = 4'd8;  cin = 0;
        #10 a = 4'd8;  b = 4'd8;  cin = 0;
        #10 a = 4'd7;  b = 4'd8;  cin = 1;
        #10 a = 4'd5;  b = 4'd6;  cin = 1;
        #10 a = 4'd15; b = 4'd15; cin = 0;
        #10 a = 4'd15; b = 4'd15; cin = 1;
        #10 $finish;
    end
endmodule

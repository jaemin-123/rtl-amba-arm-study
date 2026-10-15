module tb_mux4_0();
    reg [3:0] a, b, c, d;
    reg [3:0] sel;
    wire [3:0] out;
    
    initial begin
        #0 a = 0; b = 1; c = 2; d = 3; sel = 0;
        #10 a = 0; b = 1; c = 2; d = 3; sel = 1;
        #10 a = 0; b = 1; c = 2; d = 3; sel = 2;
        #10 a = 0; b = 1; c = 2; d = 3; sel = 3;
        #10
        $finish;
    end
    
    mux4_0 DUT(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .out(out)
    );
endmodule

module tb_mux4_1();
    reg [3:0] a, b, c, d;
    reg [3:0] sel;
    wire [3:0] out;
    
    initial begin
        #0 a = 0; b = 1; c = 2; d = 3; sel = 0;
        #10 a = 0; b = 1; c = 2; d = 3; sel = 1;
        #10 a = 0; b = 1; c = 2; d = 3; sel = 2;
        #10 a = 0; b = 1; c = 2; d = 3; sel = 3;
        #10
        $finish;
    end
    
    mux4_1 DUT(
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .out(out)
    );
endmodule

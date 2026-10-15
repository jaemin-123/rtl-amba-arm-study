module tb_mux2_0();
    reg [1:0] a, b;
    reg sel;
    wire [1:0] out;
    
    initial begin
        #0 a = 0; b = 2; sel = 0;
        #10 a = 0; b = 2; sel = 1;
        #10
        $finish;
    end
    
    mux2_0 DUT(
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
endmodule

module tb_mux2_1();
    reg [1:0] a, b;
    reg sel;
    wire [1:0] out;
    
    initial begin
        #0 a = 0; b = 2; sel = 0;
        #10 a = 0; b = 2; sel = 1;
        #10
        $finish;
    end
    
    mux2_1 DUT(
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
endmodule

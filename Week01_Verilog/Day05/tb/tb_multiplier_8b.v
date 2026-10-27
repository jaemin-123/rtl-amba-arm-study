module tb_multiplier_8b;

    reg  [7:0] opa, opb;
    wire [15:0] result;

    multiplier_8b U1 (
        .opa(opa),
        .opb(opb),
        .result(result)
    );

    initial begin
        opa = 0;   opb = 25;
        #10;
        opa = 1;   opb = 123;
        #10;
        opa = 3;   opb = 5;
        #10;
        opa = 15;  opb = 10;
        #10;
        opa = 128; opb = 2;
        #10;
        opa = 255; opb = 255;
        #10;

        $finish;
    end
    
    reg [15:0] expected;

    always @(opa or opb) begin
        expected = opa * opb;
        #1;
    
        if (result !== expected)
            $error("FAIL: %d * %d = %d (expected %d)",
                   opa, opb, result, expected);
        else
            $display("PASS: %d * %d = %d",
                     opa, opb, result);
    end

endmodule

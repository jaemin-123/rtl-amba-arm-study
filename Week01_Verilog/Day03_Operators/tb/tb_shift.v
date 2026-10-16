module tb_shift();
    reg signed [7:0] data1;
    reg [7:0] data2;
    wire [7:0] out1, out2, out3, out4;
    
    shift DUT (
        .data1(data1),
        .data2(data2),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    
    initial begin
        data1 = 8'hac; data2 = 8'h8f;
        #50 $finish;
    end
endmodule

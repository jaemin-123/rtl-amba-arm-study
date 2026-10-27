module tb_priority_encoder();
    reg [3:0] encode;
    wire [1:0] enc;
    
    priority_encoder U1 (
        .encode(encode),
        .enc(enc)
    );
    
    initial begin
        encode = 4'b0000;
        #10 encode = 4'b0001;
        #10 encode = 4'b0011;
        #10 encode = 4'b0110;
        #10 encode = 4'b1010;
        #10 encode = 4'b1111;
        #10 $finish;
    end
endmodule

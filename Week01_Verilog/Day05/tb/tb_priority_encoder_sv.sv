module tb_priority_encoder_sv;

    logic [3:0] encode;
    logic [1:0] enc_case;
    logic [1:0] enc_if;
    logic valid_case;
    logic valid_if;

    priority_encoder_sv U1 (
        .encode(encode),
        .enc(enc_case),
        .valid(valid_case)
    );

    priority_encoder_sv_1 U2 (
        .encode(encode),
        .enc(enc_if),
        .valid(valid_if)
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

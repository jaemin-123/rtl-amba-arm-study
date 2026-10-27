module priority_encoder(
    input wire [3:0] encode,
    output reg [1:0] enc
    );
    
    always @(*) begin
        casex (encode)
            4'b1xxx : enc = 2'b11;
            4'b01xx : enc = 2'b10;
            4'b001x : enc = 2'b01;
            4'b0001 : enc = 2'b00;
            default : enc = 2'bxx;
        endcase
    end
endmodule

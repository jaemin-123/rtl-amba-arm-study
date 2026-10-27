module priority_encoder_sv(
    input logic [3:0] encode,
    output logic [1:0] enc,
    output logic valid
    );
    
    always_comb begin
        valid = 1;
        
        casex (encode)
            4'b1xxx : enc = 2'b11;
            4'b01xx : enc = 2'b10;
            4'b001x : enc = 2'b01;
            4'b0001 : enc = 2'b00;
            default : begin
                enc = 2'b00;
                valid = 0;
            end
        endcase
    end
endmodule

module priority_encoder_sv_1(
    input logic [3:0] encode,
    output logic [1:0] enc,
    output logic valid
    );
    
    always_comb begin
        valid = 1'b1;
        
        if (encode[3])
            enc = 2'b11;
        else if (encode[2])
            enc = 2'b10;
        else if (encode[1])
            enc = 2'b01;
        else if (encode[0])
            enc = 2'b00;
        else begin
            enc = 2'b00;
            valid = 1'b0;
        end
    end
endmodule

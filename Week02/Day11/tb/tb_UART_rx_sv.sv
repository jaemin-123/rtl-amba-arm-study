`timescale 1ns/1ps

module tb_UART_rx_sv;

    localparam integer CLKS_PER_BIT = 8;
    
    logic clk, rst_n, rx;
    logic [7:0] rx_data_v, rx_data_sv;
    logic rx_done_v, rx_done_sv;
    
    logic [7:0] payload;
    
    UART_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) U1 (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .rx_data(rx_data_v),
        .rx_done(rx_done_v)
    );
    
    UART_rx_sv #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) U2 (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .rx_data(rx_data_sv),
        .rx_done(rx_done_sv)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        rx = 1; 
        rst_n = 0;
        payload = 8'hA6;
        
        @(negedge clk);
        rst_n = 1;
        repeat (4) @(negedge clk);
        
        @(negedge clk);
        rx = 0;                         
        repeat (CLKS_PER_BIT) @(negedge clk);
        
        for (int i = 0; i < 8; i++) begin
            rx = payload[i];
            repeat (CLKS_PER_BIT) @(negedge clk);
        end
        
        rx = 1;                       
        repeat (CLKS_PER_BIT) @(negedge clk);
    end
    
    initial begin : check_one_frame
        int done_count;
        logic previous_done;

        done_count = 0;
        previous_done = 1'b0;
    
        // 초기 리셋 + 입력 전 대기 + 10비트 프레임 이후까지 검사
        repeat (16 * CLKS_PER_BIT) begin
            @(posedge clk);
            #1;
            if (rst_n) begin
                assert (rx_done_v === rx_done_sv)
                    else $fatal(1, "V/SV done mismatch");
    
                assert (rx_data_v === rx_data_sv)
                    else $fatal(1, "V/SV data mismatch");
    
                if (rx_done_sv === 1'b1) begin
                    assert (rx_data_sv === 8'hA6)
                        else $fatal(1, "Expected A6, got %h", rx_data_sv);
                    assert (previous_done === 1'b0)
                        else $fatal(1, "rx_done wider than one clock");
                    done_count++;
                end
    
                previous_done = rx_done_sv;
            end
            else begin
                done_count = 0;
                previous_done = 0;
            end
        end
    
        assert (done_count == 1)
            else $fatal(1, "Expected one completion, got %0d", done_count);
        $display("PASS: A6 received, one completion pulse");
        $finish;
    end
endmodule

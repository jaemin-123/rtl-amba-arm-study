module tb_UART_rx_fsm_sv;

    // 두 DUT에 공통으로 넣을 입력
    logic clk, rst_n, rx;
    logic half_bit_done, bit_done;
    logic [2:0] bit_index;

    // 예상 상태를 읽기 쉬운 이름으로 선언
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;

    // 10ns부터 230ns까지, 각 상승 에지 직후의 예상 상태
    state_t expected_states [0:11] = '{
        IDLE, IDLE, START, IDLE,
        IDLE, START, DATA, DATA,
        DATA, STOP, STOP, IDLE
    };

    // Verilog DUT
    UART_rx_fsm U1(
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .half_bit_done(half_bit_done),
        .bit_done(bit_done),
        .bit_index(bit_index)
    );

    // SystemVerilog DUT
    UART_rx_fsm_sv U2(
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .half_bit_done(half_bit_done),
        .bit_done(bit_done),
        .bit_index(bit_index)
    );

    // 클록 생성
    initial clk = 1'b0;
    always #10 clk = ~clk;

    // 입력 생성
    initial begin
        rst_n = 0;
        rx = 1;
        half_bit_done = 0;
        bit_done = 0;
        bit_index = 0;

        @(negedge clk);          // 20ns
        rst_n = 1;

        @(negedge clk);          // 40ns
        rx = 0;

        @(negedge clk);          // 60ns
        rx = 1;
        half_bit_done = 1;

        @(negedge clk);          // 80ns
        half_bit_done = 0;

        @(negedge clk);          // 100ns
        rx = 0;

        @(negedge clk);          // 120ns
        half_bit_done = 1;

        @(negedge clk);          // 140ns
        half_bit_done = 0;
        bit_index = 3'd6;
        bit_done = 1;

        @(negedge clk);          // 160ns
        bit_done = 0;
        bit_index = 3'd7;

        @(negedge clk);          // 180ns
        bit_done = 1;
        rx = 1;

        @(negedge clk);          // 200ns
        bit_done = 0;

        @(negedge clk);          // 220ns
        bit_done = 1;
    end

    // 상태 자동 검사
    initial begin
        foreach (expected_states[i]) begin
            @(posedge clk);
            #1;

            assert (U1.state === U2.state)
                else $fatal(1,
                    "V/SV mismatch at %0t: V=%b SV=%b",
                    $time, U1.state, U2.state);

            assert (U2.state === expected_states[i])
                else $fatal(1,
                    "Wrong state at %0t: expected=%b actual=%b",
                    $time, expected_states[i], U2.state);

            $display(
                "PASS at %0t: expected=%b V=%b SV=%b",
                $time, expected_states[i], U1.state, U2.state);
        end

        $display("PASS: 12 state checks");
        $finish;
    end

endmodule

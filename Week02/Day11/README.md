# Week 02 · Day 11 — UART RX 8N1 구현

> Day10의 상태 전이에 타이머·데이터 저장·수신 완료 출력을 연결한다.
> 완료 여부는 맨 위 체크리스트 한 곳에서 관리한다.

## 1. 오늘의 체크리스트

- [x] Day10 FSM을 복사해 Day11 모듈 생성
- [x] 외부 rx 입력의 2단 동기화 구현
- [x] 반 비트·한 비트 카운터와 상태 전이 연결
- [x] LSB-first 데이터 8비트 저장
- [x] 정상 Stop Bit에서 rx_data 갱신 및 rx_done 1클록 펄스 생성
- [x] Verilog TB에서 1바이트 수신 파형 확인
- [x] SV TB에서 수신값·완료 펄스 자동 검사
- [ ] 짧은 Start·잘못된 Stop·연속 프레임 시험
- [x] 검증 결과와 에러 해결 기록

**기본 완료 목표**는 시뮬레이션용 8클록/비트 설정에서 정상 1바이트 수신이다. 이후 오류 입력과 연속 프레임을 추가한다.

실습 환경: **Vivado 2025.2 / xsim**, TB 시간 단위 `1ns/1ps`.

## 2. 공부 자료와 범위

- [Day10 FSM 상태 전이와 자동 검사](../Day10/README.md)
- [Day08 카운터](../Day08/README.md), [Day09 시프트 레지스터](../Day09/README.md)
- Harris 교재의 3.4절 FSM, 4.6절 FSM HDL 구현 복습
- PDF 19~21의 FF·리셋·카운터 내용을 필요한 부분만 복습
- [신경욱 교수 KOCW HDL 설계](https://www.kocw.net/home/search/kemView.do?kemId=1428200)

UART 구현은 이 문서의 자체 실습 명세를 따른다. 먼저 Verilog를 작성하고, 동작 확인 후 SV로 옮긴다.

## 3. 설계 구조와 입출력

### 3.1 Day10에서 달라지는 부분

Day10에서는 TB가 half_bit_done, bit_done, bit_index를 직접 넣었다. Day11에서는 모듈 내부 카운터가 이 조건들을 생성한다.

| 신호 | 방향·폭 | 역할 |
|---|---|---|
| clk | 입력 1비트 | 시스템 클록 |
| rst_n | 입력 1비트 | Active-low 동기 리셋 |
| rx | 입력 1비트 | 외부 UART 직렬 입력 |
| rx_data | 출력 8비트 | 가장 최근 정상 수신 바이트 |
| rx_done | 출력 1비트 | 정상 수신 시 한 클록 동안 1 |
| rx_meta, rx_sync | 내부 각 1비트 | rx의 2단 동기화 |
| state, next_state | 내부 각 2비트 | IDLE/START/DATA/STOP |
| cnt | 내부 카운터 | 상태별 경과 클록 수 |
| bit_index | 내부 3비트 | 현재 저장할 D0~D7 위치 |
| data_buf | 내부 8비트 | 수신 중인 데이터 보관 |

rx_data는 다음 정상 수신까지 값을 유지한다. 잘못된 Stop에서는 기존 rx_data를 유지하고 rx_done을 발생시키지 않는다.

### 3.2 설정

`rtl/uart_rx.v`에 `module uart_rx #(parameter integer CLKS_PER_BIT = 8)` 형태로 작성한다.

- 이번 실습은 CLKS_PER_BIT=8, HALF_BIT=4로 시작한다.
- 클록은 TB에서 20ns 주기이므로 한 비트 시간은 160ns다.
- 8N1의 8은 데이터 비트 수다. CLKS_PER_BIT=8과 각각 별개의 설정이다.
- 100MHz / 115200bps 환경에서는 약 868클록/비트다.

처음에는 cnt를 `reg [15:0] cnt;`로 선언한다. 이 실습은 짝수 CLKS_PER_BIT, 4~65536 범위를 사용한다. 홀수 분주와 주파수 오차 처리는 확장 주제다.

## 4. Verilog 직접 작성 순서

### 4.1 파일 만들기

| 파일 | 작성 내용 |
|---|---|
| rtl/uart_rx.v | 타이머·FSM·수신 데이터·출력 |
| tb/tb_uart_rx.v | 정상 1바이트 입력 및 파형 확인 |
| rtl/uart_rx_sv.sv | Verilog와 동일한 명세의 SV 구현 |
| tb/tb_uart_rx_sv.sv | V/SV 수신 결과와 정답 자동 비교 |

먼저 포트를 선언하고 Day10의 상태 상수와 상태 저장 블록을 옮긴다. 리셋은 `always @(posedge clk)`에서 처리한다.

### 4.2 rx 동기화

외부 rx는 내부 clk와 독립적으로 바뀐다. 두 FF를 연결하고 이후 FSM과 데이터 저장은 rx_sync를 사용한다.

```verilog
always @(posedge clk) begin
    if (!rst_n) begin
        rx_meta <= 1'b1;
        rx_sync <= 1'b1;
    end
    else begin
        rx_meta <= rx;
        rx_sync <= rx_meta;
    end
end
```

리셋값 1은 UART의 Idle 값이다. 이 구조는 메타안정성이 뒤 회로로 전파될 가능성을 낮추며 입력 관찰에 지연이 생긴다. 디지털 RTL 시뮬레이션에서는 이 지연을 확인한다.

### 4.3 타이머 완료 조건

```verilog
localparam integer HALF_BIT = CLKS_PER_BIT / 2;

wire half_bit_done;
wire bit_done;

assign half_bit_done = (cnt == HALF_BIT - 1);
assign bit_done      = (cnt == CLKS_PER_BIT - 1);
```

이 신호는 현재 카운트의 종료 조건이다. START에서는 half_bit_done, DATA/STOP에서는 bit_done만 사용한다.

| 현재 상태 | cnt 갱신 |
|---|---|
| IDLE | 매 상승 에지 0 |
| START | half_bit_done이면 0, 그 외 +1 |
| DATA | bit_done이면 0, 그 외 +1 |
| STOP | bit_done이면 0, 그 외 +1 |
| 리셋·그 외 상태 | 0 |

IDLE에서 rx_sync=0을 감지한 에지에 START로 진입하며 cnt=0이다. 그 뒤 네 번째 상승 에지에 반 비트 검사를 수행한다. DATA 진입 에지에도 cnt=0으로 맞추고, 이후 8클록마다 비트를 저장한다.

`cnt[3]`처럼 특정 비트를 검사하는 대신 종료값과 비교한다. cnt는 한 순차 블록에서만 구동한다.

### 4.4 상태 전이

Day10 코드를 재사용하고 rx를 rx_sync로 연결한다.

| 상태 | 전이 조건 | 다음 상태 |
|---|---|---|
| IDLE | rx_sync=0 | START |
| START | half_bit_done=1, rx_sync=0 | DATA |
| START | half_bit_done=1, rx_sync=1 | IDLE |
| DATA | bit_done=1, bit_index=7 | STOP |
| STOP | bit_done=1 | IDLE |
| 위 조건 미충족 | 기본값 next_state=state | 유지 |

조합 블록에서는 기본값을 먼저 주고 `default: next_state = IDLE;`을 둔다.

### 4.5 데이터 저장과 완료 출력

- 리셋에서 bit_index, data_buf, rx_data, rx_done을 0으로 만든다.
- IDLE에서 bit_index=0으로 준비한다.
- DATA에서 bit_done일 때 `data_buf[bit_index] <= rx_sync;`로 저장한다.
- bit_index가 7 미만이면 1 증가시키고, 7이면 유지하며 STOP으로 이동한다.
- STOP에서 bit_done이며 rx_sync=1일 때만 rx_data를 갱신하고 rx_done=1로 만든다.

```verilog
// 데이터·출력을 관리하는 순차 블록의 리셋 해제 분기
rx_done <= 1'b0;

if (state == STOP && bit_done && rx_sync) begin
    rx_data <= data_buf;
    rx_done <= 1'b1;
end
```

매 클록 기본값 0을 예약하고 정상 완료 조건에서 1을 예약하므로 rx_done은 한 클록 펄스가 된다.

DATA의 D7 저장과 STOP의 rx_data 갱신은 서로 다른 에지에서 이루어진다. 이 시점 구분을 지키면 최종 바이트에 D7도 포함된다.

LSB-first이므로 D0를 data_buf[0], D7을 data_buf[7]에 넣는다. Day09의 `{q[6:0], sin}`을 그대로 사용하면 이 수신 순서에서는 비트 순서가 뒤집히므로 저장 방향을 확인한다.

## 5. TB와 SV 자동 검증

### 5.1 먼저 정상 1바이트

clk=0에서 시작해 `always #10 clk = ~clk;`로 클록을 만든다. rx=1, rst_n=0으로 시작하고 하강 에지에 리셋을 해제한다. 정상 프레임은 그 후 4클록 이상 대기한 뒤 전송한다.

데이터는 8'hA6으로 시작한다.

| 순서 | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop |
|---|---|---|---|---|---|---|---|---|---|---|
| rx | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 0 | 1 | 1 |

각 값을 8클록 동안 유지한다. 입력은 하강 에지에서 바꾼다. for를 사용하면 다음처럼 D0부터 전송할 수 있다.

```systemverilog
// payload는 미리 선언한 logic [7:0], 값은 8'hA6
@(negedge clk);
rx = 0;                         // Start
repeat (CLKS_PER_BIT) @(negedge clk);

for (int i = 0; i < 8; i++) begin
    rx = payload[i];
    repeat (CLKS_PER_BIT) @(negedge clk);
end

rx = 1;                         // Stop
repeat (CLKS_PER_BIT) @(negedge clk);
```

Verilog TB에서는 반복 변수 `integer i;`를 블록 밖에 선언한다. 입력 전송 코드에는 시스템 클록을 반전시키는 코드를 추가하지 않는다.

### 5.2 파형에서 볼 신호

rx, rx_sync, state, cnt, bit_index, data_buf, rx_data, rx_done을 추가한다.

- START 중앙에서 Low를 재확인한다.
- DATA에서 cnt가 종료될 때마다 bit_index가 증가하고 지정 비트가 저장된다.
- 정상 Stop 중앙에서 rx_data=A6, rx_done=1이 된다.
- 다음 클록에 rx_done=0이 되고 rx_data는 A6을 유지한다.

2단 동기화 지연 때문에 외부 Start 경계와 state 진입 시각에는 차이가 생긴다.

### 5.3 SV 비교 구조

SV RTL은 `logic`, `typedef enum logic [1:0]`, `always_ff`, `always_comb`를 사용한다. V/SV에 동일한 rx를 연결하고 출력은 rx_data_v/rx_data_sv, rx_done_v/rx_done_sv로 분리한다.

입력 블록과 검사 블록을 나눈다. rx_done은 Stop 비트가 끝나기 전에 발생할 수 있으므로 검사 블록은 전송 중에도 실행해야 한다.

아래는 **정상 A6 한 프레임 전용 검사 블록**이다. CLKS_PER_BIT=8을 기준으로 리셋 해제 후 4클록 대기하고, 프레임 하나를 보낸 뒤 rx=1로 유지하는 입력 블록과 함께 사용한다.

```systemverilog
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
```

기대값은 TB에서 정하고 V/SV 일치와 정답값을 함께 검사한다.
TB의 done_count는 받은 완료 펄스 수를 세는 정수다. previous_done은 이전 검사 시점의 완료 신호를 저장한다. assert 검사는 #1 뒤에서 실행한다.

### 5.4 정상 프레임 이후 추가할 시험

| 시험 | 입력 | 기대 결과 |
|---|---|---|
| 여러 패턴 | 00, FF, 55, A6 | 각 바이트와 rx_data 일치 |
| 짧은 Start | Low를 1클록만 준 뒤 High 유지 | 완료 펄스 없음 |
| 잘못된 Stop | Stop을 한 비트 동안 0으로 보내고 High 복귀 | 해당 프레임 완료 펄스 없음, 기존 rx_data 유지 |
| 연속 프레임 | Stop 1비트 직후 다음 Start | 바이트 순서대로 완료 펄스 |
| 수신 중 리셋 | DATA 도중 rst_n=0 | 다음 상승 에지에 IDLE·출력 초기화 |

시험은 하나씩 추가한다. 기대 바이트와 완료 횟수, 종료 시점도 함께 맞춘다. 잘못된 Stop 뒤에는 High를 충분히 유지해 입력을 Idle로 돌린다.

## 6. Python / C 및 진행 순서

오늘은 기존 카운터와 FSM을 연결하는 데 집중한다. Python은 바이트를 비트 순서로 확인하는 짧은 계산만 선택으로 사용한다.

```python
value = 0xA6
print([(value >> i) & 1 for i in range(8)])
# [0, 1, 1, 0, 0, 1, 0, 1]
```

C는 ARM 소프트웨어 단계에서 진행한다.

먼저 4.1~4.3의 포트·동기화·카운터를 작성하고, 그다음 FSM에 연결한다. 정상 Verilog 파형을 확인한 뒤 SV 자동 비교와 추가 시험으로 넘어간다.

## 7. 검증 결과

### 7.1 정상 A6 수신

Vivado 2025.2에서 Verilog 단독 TB와 V/SV 공통 입력 TB를 실행하고 공유한 파형을 확인했다.

| 항목 | 관찰 결과 |
|---|---|
| 입력 payload | `8'hA6` = 166 |
| 시간순 D0→D7 | 0, 1, 1, 0, 0, 1, 0, 1 |
| rx_sync | rx를 지연해서 내부 클록에 맞춰 관찰 |
| bit_index | DATA에서 0~7 순서로 진행 |
| data_buf | 수신 과정에서 0→2→6→38→166으로 갱신 |
| rx_data_v / rx_data_sv | 정상 Stop 검사 후 둘 다 A6, 이후 유지 |
| rx_done_v / rx_done_sv | 같은 시점에 한 클록 폭의 완료 펄스 관찰 |
| 상태 | IDLE→START→DATA→STOP→IDLE |

파형의 직렬 전송 순서는 D0부터 읽는다. 버스 표기는 D7부터이므로 `1010_0110 = A6`가 된다.

SV TB에는 V/SV 데이터·완료 신호 일치, 완료 시 A6 기대값, 연속 두 클록 완료 금지, 최종 완료 횟수 1회 검사를 넣었다. 공유된 파형에서는 정상 동작을 확인했다. 최종 PASS 콘솔 로그는 별도로 첨부할 예정이다.

짧은 Start·잘못된 Stop·연속 프레임·수신 중 리셋은 아직 실행 결과를 확인하지 않았다.

### 7.2 카운터 조건 정리와 합성 비교

기존의 여러 `else if` 초기화 조건을 하나의 `cnt_clear`로 묶어 RTL Analysis와 합성 자원을 비교했다.

```verilog
wire cnt_clear;

assign cnt_clear =
    (state == IDLE) ||
    (next_state != state) ||
    ((state == DATA || state == STOP) && bit_done);

always @(posedge clk) begin
    if (!rst_n)
        cnt <= 16'd0;
    else if (cnt_clear)
        cnt <= 16'd0;
    else
        cnt <= cnt + 16'd1;
end
```

RTL 그림에서는 카운터 앞의 연속 MUX가 조건 비교·AND·OR와 하나의 MUX로 표현됐다. 하지만 합성 후 자원 수는 수정 전후 동일했다.

| 자원 | 수정 전 | 수정 후 |
|---|---:|---:|
| LUT | 25 | 25 |
| FF | 40 | 40 |
| IO | 12 | 12 |
| BUFG | 1 | 1 |

동일한 동작을 다른 문법으로 표현해도 합성 도구가 같은 자원 수로 구현할 수 있다. 이번 변경에서 면적 개선은 확인되지 않았으며, 자원 수만으로 타이밍·전력까지 같다고 판단하지 않는다. 타이밍·전력 개선 측정은 하지 않았다.

## 8. 에러 및 해결

### 8.1 TB 파라미터 연결 문법

- 문제: 인스턴스 이름 뒤에 `#(...)`를 넣고 `CLKS_PER_BIT = CLKS_PER_BIT`로 작성해 오류 표시 발생.
- 수정: TB에 상수를 선언하고 모듈 이름 뒤, 인스턴스 이름 앞에서 이름 기반 파라미터 연결을 사용했다.

```systemverilog
localparam integer CLKS_PER_BIT = 8;

UART_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
) U1 (
    // 포트 연결
);
```

TB는 상승 에지에서 동기 리셋을 한 번 이상 수행한 뒤 하강 에지에서 rst_n을 1로 해제한다.

### 8.2 DATA의 begin/end 범위

- 문제: `if (bit_done)` 아래 저장문만 조건에 포함되어 bit_index가 DATA의 매 클록마다 증가할 수 있었다.
- 수정: 저장과 인덱스 증가를 같은 begin/end로 묶었다.

```verilog
if (bit_done) begin
    data_buf[bit_index] <= rx_sync;
    if (bit_index < 3'd7)
        bit_index <= bit_index + 3'd1;
end
```

bit_index와 data_buf는 조합 상태 전이 블록에서 대입하지 않고, 각각 한 순차 블록에서 관리한다.

### 8.3 SV 블록 지역 변수 초기화 경고

- 메시지: 선언과 동시에 초기화한 변수에 automatic 또는 static 명시가 필요하다는 경고.
- 수정: `int done_count;`, `logic previous_done;`로 먼저 선언하고, 아래에서 `=`로 초기값을 대입했다.
- 검사 블록의 수정 예시는 5.3절에 반영했다.

### 8.4 증분 합성 체크포인트 경고

`[Synth 8-6895]`는 이전 DCP가 현재 설계의 incremental synthesis에 적합하지 않아 일반 합성으로 진행한다는 메시지였다.

RTL 오류를 지적하는 메시지는 아니며, 정확한 체크포인트 부적합 원인은 확인하지 않았다. 필요하면 Settings → Synthesis → Incremental Synthesis에서 **Disable incremental compile**을 선택하고 전체 합성을 다시 실행한다. 이 설정 변경으로 경고가 해소됐는지는 별도 확인이 필요하다.

## 9. 학습 내용 및 다음 보완

- 2단 FF는 송수신 클록 자체를 일치시키는 회로가 아니라 외부 rx를 내부 clk로 받아 메타안정성 전파 가능성을 낮추는 구조다.
- `parameter integer CLKS_PER_BIT`는 설계 구성 시 결정되는 정수 상수이며, 그 선언 자체가 32비트 저장 레지스터를 만드는 것은 아니다.
- `repeat (CLKS_PER_BIT) @(negedge clk);`는 한 비트를 필요한 시간 동안 유지하기 위한 대기다.
- cnt, state, 데이터·출력의 순차 블록과 next_state 조합 블록을 역할별로 나눴다. 같은 레지스터를 여러 블록에서 구동하지 않는다.
- data_buf는 직렬 비트를 조립하고, rx_data는 완성된 바이트를 유지한다. 이 구조만으로 다음 모듈의 준비 상태를 확인하거나 여러 바이트를 큐에 보관하지는 않는다.
- SV에서는 logic, enum, always_ff, always_comb를 사용했다. assign으로 구동하는 wire는 그대로 사용할 수 있다.
- TB의 두 initial은 동시에 시작한다. 입력은 하강 에지에 바꾸고, 검사는 상승 에지 후 #1에서 갱신 결과를 읽는다.
- previous_done은 이전 검사값이다. 현재 펄스를 검사한 다음 값을 갱신해야 한다.
- 완료 시 데이터 검사와 최종 완료 횟수 검사를 함께 해야, 완료가 전혀 발생하지 않는 오류도 검출할 수 있다.
- RTL Analysis의 도형 수와 최종 합성 자원 수는 다를 수 있다. 코드 길이 감소가 곧 하드웨어 면적 감소는 아니다.
- 다음에는 00/FF/55 패턴과 오류·연속 프레임을 하나씩 추가한다. 카운터 폭 최적화는 기능 검증 후 별도 비교한다.

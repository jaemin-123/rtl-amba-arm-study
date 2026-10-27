# Week 01 - Day 05: Verilog 조건문과 반복문

## 1. 학습 목표
- [ ] `if`, `else if`, Nested if 조건문 이해
- [ ] `case`, `casez`, `casex`의 동작 차이 이해
- [ ] 불완전한 조건문으로 발생하는 Latch 문제 이해
- [ ] 동기식/비동기식 Reset의 차이 이해
- [ ] `forever`, `repeat`, `while`, `for` 반복문 이해
- [ ] Priority Encoder 및 Shift-Add Multiplier 구현
- [ ] SystemVerilog `always_comb` 활용
- [ ] Vivado에서 RTL 및 Testbench 검증

## 2. 공부 자료
- **강의:** [KOCW - Verilog HDL 및 Vivado 실습](http://www.kocw.net/home/search/kemView.do?kemId=1428200)
- **수강 범위:** if 조건문, case 문, 반복문
- **참고 자료:**
  - `11.pdf` - if 조건문 (5.3절)
  - `12.pdf` - case 문 (5.4절)
  - `13.pdf` - 반복문 (5.5절)
- **개발 환경:** Vivado 2022.2 / Verilog HDL / SystemVerilog

## 3. 학습 내용 정리

### 3.1 if 조건문

`if` 문은 조건식의 결과에 따라 실행할 문장을 선택한다.

```verilog
always @(*) begin
    if (sel)
        out = b;
    else
        out = a;
end
```

- `if`와 `else if`를 이용하여 여러 조건을 처리할 수 있다.
- Nested if를 작성할 때 `else`는 가장 가까운 미완성 `if`와 연결된다.
- 조합논리에서 모든 조건에 출력값을 할당하지 않으면 Latch가 발생할 수 있다.

### 3.2 case 문

`case` 문은 조건식에 일치하는 항목의 문장을 실행한다.

```verilog
always @(*) begin
    case (sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 1'b0;
    endcase
end
```

| 구분 | 특징 |
|---|---|
| `case` | `0`, `1`, `x`, `z`를 구분하여 비교 |
| `casez` | `z` 및 `?`를 Don't Care로 처리 |
| `casex` | `x`, `z`, `?`를 Don't Care로 처리 |

- `casez`는 와일드카드 패턴을 표현할 때 사용할 수 있다.
- `casex`는 실제 Unknown 상태까지 무시하여 오류를 감출 수 있으므로 합성 가능한 RTL에서 사용을 피하는 것이 좋다.
- 조합논리에서 필요한 분기를 빠뜨리지 않도록 `default`나 기본값 할당을 사용한다.

### 3.3 Priority Encoder

여러 입력이 동시에 1인 경우 우선순위가 가장 높은 입력의 위치를 출력하는 회로이다.

**4비트 Priority Encoder 예시**

| 입력 | 출력 | 의미 |
|---|---|---|
| `0001` | `00` | bit 0 선택 |
| `001x` | `01` | bit 1 선택 |
| `01xx` | `10` | bit 2 선택 |
| `1xxx` | `11` | bit 3 선택 |

※ `x`는 위 표에서 Don't Care 패턴을 의미한다.

- bit 3에 가장 높은 우선순위를 부여한다.
- 실제 Verilog의 Unknown 값 `x`와 패턴의 Don't Care 의미를 구분해야 한다.
- 입력이 `0000`인 경우 유효한 선택이 없으므로 출력값과 `valid` 처리 방식을 별도로 정의한다.

### 3.4 동기식 / 비동기식 Reset

**동기식 Reset**

```verilog
always @(posedge clk) begin
    if (!rst_n)
        q <= 1'b0;
    else
        q <= d;
end
```

**비동기식 Reset**

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else
        q <= d;
end
```

- 동기식 Reset은 Clock Edge에서 상태가 갱신된다.
- 비동기식 Reset은 Clock Edge와 관계없이 Reset이 활성화되면 상태가 변경될 수 있다.
- 순차논리회로에서는 일반적으로 Nonblocking Assignment(`<=`)를 사용한다.

### 3.5 반복문

| 반복문 | 기능 | 주요 사용 |
|---|---|---|
| `forever` | 무한 반복 | Testbench Clock 생성 |
| `repeat` | 지정된 횟수 반복 | 고정 횟수 연산 |
| `while` | 조건이 참인 동안 반복 | 조건 기반 연산 |
| `for` | 반복 변수로 횟수 제어 | 배열, 반복 연산, 테스트 |

**forever 예제**

```verilog
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end
```

**for 예제**

```verilog
integer i;

initial begin
    for (i = 0; i < 8; i = i + 1)
        $display("i = %0d", i);
end
```

- `forever`는 Testbench에서 주기 신호를 생성할 때 활용할 수 있다.
- `repeat`는 일정 횟수의 연산을 반복한다.
- `while`은 반복 종료 조건이 명확해야 한다.
- 합성 가능한 RTL에서는 반복 횟수와 하드웨어 구현 가능성을 고려해야 한다.

### 3.6 Shift-Add Multiplier

`repeat` 반복문을 이용하여 Shift-Add 방식으로 곱셈을 구현한다.

동작 과정:
1. 결과값을 0으로 초기화
2. Multiplier의 LSB 확인
3. LSB가 1이면 Multiplicand를 결과값에 더함
4. Multiplicand는 왼쪽으로 Shift
5. Multiplier는 오른쪽으로 Shift
6. 지정된 비트 수만큼 반복

- 곱셈을 덧셈과 Shift 연산으로 표현할 수 있다.
- 강의의 조합논리 예제에서 `repeat`는 반복 횟수만큼 연산 구조가 전개될 수 있으며, 자동으로 여러 Clock Cycle에 나누어 실행되는 것은 아니다.

## 4. RTL 설계 및 실습

### 4.1 D Flip-Flop - 비동기 Set/Reset
- **참고:** `11.pdf` 코드 5.10
- **RTL 파일:** `rtl/dff_sr_async.v`
- **TB 파일:** `tb/tb_dff_sr_async.v`
- **목표:** 비동기 Set/Reset과 Clock 기반 데이터 갱신 확인
- **검증:** Reset 우선순위, Set, Clock Edge, 정상 데이터 입력

### 4.2 Priority Encoder
- **참고:** `12.pdf` 코드 5.12, 5.13
- **RTL 파일:** `rtl/priority_encoder.v`
- **TB 파일:** `tb/tb_priority_encoder.v`
- **목표:** `case` 문을 이용한 4비트 Priority Encoder 구현
- **검증:** 우선순위와 입력 `0000` 처리 확인

### 4.3 Shift-Add Multiplier
- **참고:** `13.pdf` 코드 5.14
- **RTL 파일:** `rtl/multiplier_8b.v`
- **TB 파일:** `tb/tb_multiplier_8b.v`
- **목표:** `repeat`와 Shift 연산을 이용한 8비트 곱셈기 구현
- **검증:** 일반 곱셈 연산(`*`)의 결과와 비교

### 4.4 Bit Counter - 선택 실습
- **참고:** `13.pdf` 코드 5.15
- **RTL 파일:** `rtl/bit_counter.v`
- **TB 파일:** `tb/tb_bit_counter.v`
- **목표:** 입력 데이터에서 1인 비트의 개수를 계산
- **검증:** 0개, 1개, 여러 개, 8개인 경우 확인

## 5. 언어별 연계 학습

### 5.1 SystemVerilog - 권장

기존 Priority Encoder를 SystemVerilog로 다시 구현하여 비교한다.

- [ ] `reg` 대신 `logic` 사용
- [ ] `always @(*)` 대신 `always_comb` 사용
- [ ] `casez` 또는 명시적 우선순위 조건의 동작 이해
- [ ] 기존 Verilog와 출력 비교

**추가 RTL:** `rtl/priority_encoder_sv.sv`

**추가 TB:** 기존 Priority Encoder Testbench 확장

### 5.2 Python - 선택

Shift-Add Multiplier의 예상 결과를 계산하는 Reference Model 작성

- [ ] Python으로 8비트 곱셈 입력 생성
- [ ] 예상 결과 계산
- [ ] RTL 시뮬레이션 결과와 비교

**추가 파일:** `python/multiplier_reference.py`

※ 이번 Day05에서는 Python 자동화가 필수는 아니며, RTL 검증을 완료한 이후 진행한다.

### 5.3 C / ARM Software

이번 학습에서는 진행하지 않음.

ARM Software와 Memory-mapped I/O를 학습하는 주차에서 연결할 예정.

## 6. 검증 결과

### 테스트 항목
- [ ] 비동기 Set/Reset DFF 동작 확인
- [ ] Priority Encoder 우선순위 확인
- [ ] 입력 `0000` 예외 처리 확인
- [ ] 8비트 Multiplier 연산 결과 확인
- [ ] `repeat` 기반 곱셈 결과와 `*` 결과 비교
- [ ] SystemVerilog Priority Encoder 출력 비교
- [ ] Bit Counter 동작 확인 (선택)

### 예상 결과 / 실제 결과

| 테스트 항목 | 예상 결과 | 실제 결과 |
|---|---|---|
| DFF Reset | Reset 활성화 시 Q=0 | 확인 |
| DFF Set | Set 활성화 시 Q=1 | 확인 |
| Priority Encoder `1000` | `11` | 미확인 |
| Priority Encoder `0110` | `10` | 미확인 |
| Priority Encoder `0011` | `01` | 미확인 |
| Multiplier `15 × 10` | 150 | 미확인 |
| Multiplier `255 × 255` | 65025 | 미확인 |
| Bit Counter `10101010` | 4 | 미확인 |

### 시뮬레이션 파형 및 로그
- D Flip-Flop:
  <img width="1030" height="248" alt="image" src="https://github.com/user-attachments/assets/8b37acfa-8be0-43d8-8635-c4ffdbccbedc" />

- Priority Encoder:
- Shift-Add Multiplier:
- SystemVerilog 비교:
- Bit Counter (선택):

## 7. 에러 및 해결
- **발생한 문제:**
- **원인:**
- **수정한 RTL/SV/TB 코드:**
- **변경 전후 결과:**

## 8. 학습 내용 및 느낀 점
- **새롭게 이해한 개념:**
- **기존에 잘못 알고 있던 부분:**
- **추가로 공부할 내용:**

## 9. 다음 학습에서 보완할 것
- `always_comb`와 `always_ff` 활용
- `if`, `case` 문을 이용한 조합논리 설계
- Latch 발생 조건과 해결 방법
- 반복문을 이용한 하드웨어 구조와 합성 결과 분석
- Priority Encoder와 Multiplier의 자동 검증 확대

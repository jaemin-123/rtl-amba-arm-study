# Week 01 - Day 04: Verilog 모델링과 할당문

## 1. 학습 목표
- [x] Gate Primitive를 이용한 게이트 수준 모델링 이해
- [x] buf, not 및 3상태 버퍼의 동작 이해
- [x] Gate Delay, Net Delay, Inertial Delay 이해
- [x] 연속 할당문(`assign`)과 절차형 할당문의 차이 이해
- [x] `always`와 `initial` 구문의 동작 이해
- [x] Sensitivity List의 역할 이해
- [x] Blocking(`=`)과 Nonblocking(`<=`) 할당문의 차이 이해
- [x] RTL 및 Testbench 작성 후 시뮬레이션 검증

## 2. 공부 자료
- **강의:** [KOCW - Verilog HDL 및 Vivado 실습](http://www.kocw.net/home/search/kemView.do?kemId=1428200)
- **수강 범위:** 게이트 수준 모델링(1)~(2), 할당문, 행위수준 모델링, 절차형 할당문
- **참고 자료:**
  - `06.pdf` - 게이트 수준 모델링(1)
  - `07.pdf` - 게이트 수준 모델링(2)
  - `08.pdf` - 할당문
  - `09.pdf` - 행위수준 모델링
  - `10.pdf` - 절차형 할당문
- **개발 환경:** Vivado 2022.2 / Verilog HDL

## 3. 학습 내용 정리

### 3.1 Gate Primitive

Verilog에서 미리 정의된 게이트 프리미티브를 이용하여 논리회로를 모델링할 수 있다.

| 구분 | Primitive | 설명 |
|---|---|---|
| 논리 게이트 | `and`, `or`, `nand`, `nor`, `xor`, `xnor` | 기본 논리 연산 |
| 단일 입력 게이트 | `buf`, `not` | 버퍼 및 반전 |
| 3상태 게이트 | `bufif0`, `bufif1`, `notif0`, `notif1` | 제어 입력에 따라 출력 활성화 |
| 기타 | `pullup`, `pulldown` 등 | 풀업 및 풀다운 모델링 |

- Gate Primitive는 별도의 모듈 정의 없이 인스턴스화할 수 있다.
- 포트는 출력이 먼저 나오며, 이후 입력 신호를 연결한다.
- 게이트의 상승 및 하강 지연을 지정할 수 있다.

### 3.2 Gate Level Modeling

게이트 프리미티브를 이용하여 논리회로를 직접 구성하는 방식이다.

```verilog
and U1(out1, a, b);
or  U2(out2, a, b);
xor U3(out3, a, b);
```

### 3.3 3상태 버퍼 (Tri-state Buffer)

3상태 버퍼는 제어 신호에 따라 출력값을 전달하거나 High-Impedance(`z`) 상태로 만든다.

```verilog
bufif1 U1(out, data, enable);
```

- `enable = 1`: 입력 데이터가 출력으로 전달
- `enable = 0`: 출력이 `z` 상태

### 3.4 Gate Delay와 Net Delay

**Gate Delay**
- 게이트 입력의 변화가 출력에 반영되기까지의 지연
- Rising Delay, Falling Delay, Turn-off Delay 등이 존재

**Net Delay**
- Driver 값의 변화가 Net에 반영되기까지의 지연

**Inertial Delay**
- 지정된 지연 시간보다 짧은 입력 변화가 출력에 반영되지 않는 특성
- 짧은 펄스가 제거되는 현상을 시뮬레이션으로 확인할 수 있음

```verilog
and #30 U1(out, a, b);
```

### 3.5 연속 할당문 (Continuous Assignment)

연속 할당문은 `assign`을 사용하여 Net 자료형에 값을 할당한다.

```verilog
wire y;
assign y = a & b;
```

- 입력값의 변화에 따라 출력값이 갱신된다.
- 조합논리회로 모델링에 사용된다.

### 3.6 행위수준 모델링 (Behavioral Modeling)

`always` 구문은 Sensitivity List에 지정된 신호의 변화 또는 특정 이벤트에 따라 실행된다.

**조합논리회로**

```verilog
always @(*) begin
    if (sel)
        out = b;
    else
        out = a;
end
```

**순차논리회로**

```verilog
always @(posedge clk) begin
    q <= d;
end
```

- 조합논리 모델링에서는 모든 입력 변화를 반영해야 한다.
- `always @(*)`는 감지신호목록을 자동으로 구성한다.
- 순차논리 모델링에서는 Clock Edge를 기준으로 동작하도록 작성할 수 있다.

### 3.7 Initial 구문

`initial` 블록은 시뮬레이션 시작 시 한 번 실행된다.

```verilog
initial begin
    clk = 1'b0;
end

always #5 clk = ~clk;
```

- 주로 Testbench에서 초기값 설정과 입력 신호 생성에 사용
- `#5`는 지정된 시간 단위만큼 지연을 의미
- 지연 없이 반복되는 `always` 구문은 무한 루프를 발생시킬 수 있음

### 3.8 Blocking과 Nonblocking

| 구분 | Blocking | Nonblocking |
|---|---|---|
| 할당 기호 | `=` | `<=` |
| 동작 방식 | 현재 문장이 값을 갱신한 뒤 다음 문장 실행 | 우변을 평가하고 예약된 시점에 좌변 갱신 |
| 주 사용처 | 조합논리회로 | 순차논리회로 |

**Blocking**

```verilog
always @(posedge clk) begin
    a = b;
    b = a;
end
```

**Nonblocking**

```verilog
always @(posedge clk) begin
    a <= b;
    b <= a;
end
```

두 방식에서 `a`, `b`의 값이 어떻게 달라지는지 비교할 수 있다.

## 4. RTL 설계 및 실습

### 4.1 Full Adder - Gate Primitive
- **참고:** `06.pdf`
- **RTL 파일:** `rtl/full_adder_gate.v`
- **TB 파일:** `tb/tb_full_adder_gate.v`
- **목표:** 게이트 프리미티브를 이용한 Full Adder 구현
- **검증:** A, B, Cin의 전체 8가지 입력 조합

### 4.2 4-bit Adder - Continuous Assignment
- **참고:** `08.pdf`
- **RTL 파일:** `rtl/adder4.v`
- **TB 파일:** `tb/tb_adder4.v`
- **목표:** `assign`을 이용한 4비트 가산기 구현
- **검증:** Sum, Carry-out, Carry-in 동작 확인

### 4.3 MUX2 - assign / always 비교
- **참고:** `08.pdf`, `09.pdf`
- **RTL 파일:** `rtl/mux2_assign.v`, `rtl/mux2_always.v`
- **TB 파일:** `tb/tb_mux2_compare.v`
- **목표:** 동일한 기능을 연속 할당문과 행위수준 모델링으로 구현하여 차이 이해
- **검증:** 두 가지 방식의 출력이 일치하는지 확인

### 4.4 Gate Delay / Inertial Delay
- **참고:** `07.pdf`, `08.pdf`
- **실습 파일:** `tb/tb_inertial_delay.v`
- **목표:** 지연 시간보다 짧은 펄스의 출력 반영 여부 확인
- **검증:** 입력 펄스 폭과 출력 변화 비교

### 4.5 Blocking / Nonblocking 비교
- **참고:** `10.pdf`
- **TB 파일:** `tb/tb_assignment_compare.v`
- **목표:** 두 할당 방식의 실행 순서 및 결과 비교
- **검증:** Clock Edge에 따른 A, B 변화 확인

## 5. 검증 결과

### 테스트 항목
- [x] Full Adder 전체 입력 조합 검증
- [x] 4-bit Adder의 Carry-in/Carry-out 검증
- [x] assign / always(if) MUX 출력 비교
- [x] Inertial Delay의 짧은 펄스 제거 확인
- [x] Blocking / Nonblocking 시뮬레이션 비교

### 예상 결과 / 실제 결과

| 테스트 항목 | 예상 결과 | 실제 결과 |
|---|---|---|
| Full Adder | 모든 입력 조합에 대해 Sum/Cout 일치 | 확인 |
| 4-bit Adder | Carry-in을 포함한 덧셈 정상 동작 | 확인 |
| MUX2 비교 | 두 가지 방식의 출력 일치 | 확인 |
| Inertial Delay | 지연보다 짧은 펄스가 반영되지 않음 | 확인 |
| Blocking | 순차 할당에 따른 값 갱신 | 확인 |
| Nonblocking | 이전 값을 기준으로 갱신 | 확인 |

### 시뮬레이션 파형 및 로그
- Full Adder:
  <img width="1032" height="166" alt="image" src="https://github.com/user-attachments/assets/0b129093-a085-4f62-9657-0e2ff22b3813" />

- 4-bit Adder:
  <img width="1033" height="172" alt="image" src="https://github.com/user-attachments/assets/2d9f876c-a090-411f-ab5a-84be39078fc6" />

- MUX2:
  <img width="1031" height="170" alt="image" src="https://github.com/user-attachments/assets/856b0448-fc73-4624-a0f9-4e01bf61778e" />

- Inertial Delay:
  <img width="1028" height="155" alt="image" src="https://github.com/user-attachments/assets/a932ec44-a8fa-473c-8ba0-796e23280c11" />

- Blocking / Nonblocking:
  <img width="1029" height="194" alt="image" src="https://github.com/user-attachments/assets/9f20cf9e-76f2-4f49-bbd8-5c0b33af0e51" />


## 6. 에러 및 해결

- **발생한 문제:**
  - MUX 비교 실습에서 `mux2_assign`만 인스턴스화하여 `always` 방식과 출력 비교가 불가능했음
  - Inertial Delay 실습에서 `#30`을 적용했지만 출력이 약 60ns까지 `x`로 유지되는 현상이 발생함

- **원인:**
  - 두 MUX 모듈의 출력 신호를 각각 선언하고 연결하지 않았음
  - 입력 변화로 인해 예약된 출력 변경이 취소되어 초기 `x` 상태가 예상보다 오래 유지됨

- **수정한 RTL/TB 코드:**
  - `mux2_assign`과 `mux2_always`를 모두 인스턴스화하고, 출력을 `out_assign`, `out_always`로 분리함
  - Delay 실습에서는 입력 변화 시점과 출력 지연의 관계를 파형으로 분석함

- **변경 전후 결과:**
  - 동일한 입력 조건에서 두 MUX의 출력을 비교할 수 있도록 개선함
  - `#30`은 입력을 지연시키는 것이 아니라 출력 변화를 예약하며, Inertial Delay에 의해 짧은 펄스가 제거될 수 있음을 이해함

## 7. 학습 내용 및 느낀 점

- **새롭게 이해한 개념:**
  - `assign`과 `always @(*)`는 서로 다른 방식으로 동일한 조합논리를 구현할 수 있음
  - Gate Delay와 Inertial Delay를 통해 입력 펄스 폭에 따라 출력 변화가 반영되지 않을 수 있음을 확인함

- **기존에 잘못 알고 있던 부분:**
  - `always`는 순차논리뿐 아니라 조합논리에도 사용할 수 있다는 점을 이해함
  - `#30`을 단순한 입력 지연으로 생각했으나, 출력 변경 예약과 취소에 의해 동작한다는 점을 이해함

- **추가로 공부할 내용:**
  - SystemVerilog의 `always_comb`, `always_ff` 사용법
  - Blocking/Nonblocking Assignment와 Race Condition
  - 불완전한 조건문으로 발생하는 Latch 문제
  - Verilog 시뮬레이션 지연과 실제 FPGA Timing Delay의 차이

## 8. 다음 학습에서 보완할 것
- Blocking / Nonblocking 할당문의 동작 심화
- 조합논리와 순차논리에서 올바른 할당 방식 사용
- Sensitivity List와 시뮬레이션 결과의 관계
- D Flip-Flop 및 FSM 설계에 적용

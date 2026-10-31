# Week 01 - Day 06: 8-bit ALU 설계 및 자동 검증

## 1. 학습 목표
- [x] Day01~Day05 Verilog 핵심 문법 복습
- [x] `case` 문을 이용한 8-bit ALU 구현
- [x] ADD, SUB, AND, OR, XOR 5개 연산 구현
- [x] 미사용 Opcode에 대한 기본 출력 처리
- [x] SystemVerilog Testbench의 `task`, `assert` 활용
- [x] 랜덤 입력 100개 자동 검증
- [x] Vivado Synthesis 및 Utilization Report 확인
- [x] Latch 추론 여부 확인

## 2. 공부 자료
- 기존 Day01~Day05 학습 README 및 RTL 코드
- Verilog 연산자, `always @(*)`, `case`, Blocking Assignment
- SystemVerilog `logic`, `task automatic`, `assert`
- Vivado RTL Simulation 및 Synthesis

## 3. 핵심 개념

### 3.1 ALU (Arithmetic Logic Unit)
ALU는 입력 데이터에 대해 산술 및 논리 연산을 수행하는 조합논리 블록이다.

- `opcode`로 수행할 연산 선택
- ADD/SUB는 산술 연산
- AND/OR/XOR는 비트 단위 논리 연산
- `case`와 `default`로 출력 결정

### 3.2 조합논리 설계
- `always @(*)`에서 Blocking Assignment(`=`) 사용
- 모든 Opcode에 대해 결과를 할당하여 Latch 방지
- 출력은 입력에 따라 결정되며 Clock을 사용하지 않음

### 3.3 자동 검증
- Testbench에서 입력 및 예상 결과 생성
- DUT 출력과 Expected Value 비교
- `task automatic`으로 반복 검증 코드 재사용
- `assert`로 PASS/FAIL 판정

### 3.4 합성 검증
- Vivado Synthesis 실행
- Utilization Report에서 LUT 등의 자원 사용 확인
- 합성 메시지에서 Latch 관련 경고 확인

## 4. RTL 설계 및 실습

### 4.1 8-bit ALU 구현
- **RTL:** `rtl/alu8.v`
- **목표:** 5개 연산과 기본 출력 구현

| Opcode | 연산 |
|---|---|
| 000 | ADD |
| 001 | SUB |
| 010 | AND |
| 011 | OR |
| 100 | XOR |
| 101~111 | 0 출력 |

### 4.2 SystemVerilog Testbench 및 자동 검증

- **TB 파일:** `tb/tb_alu8_sv.sv`
- **검증 대상:** `alu8.v`, `alu8_sv.sv`
- **목표:** Verilog와 SystemVerilog로 작성한 ALU의 출력 비교 및 자동 검증
- **검증 방식:** Directed Test 8개 + Random Test 100개

#### 4.2.1 Verilog TB와 SystemVerilog TB 비교

| 구분 | Verilog | SystemVerilog |
|---|---|---|
| 신호 선언 | `reg`, `wire` | `logic` |
| Opcode 정의 | `localparam` | `typedef enum` |
| 예상 결과 계산 | `always`, `case` | `function automatic` |
| 반복 검증 | `initial`, `always` | `task automatic` |
| 결과 비교 | `if`, `$error` | `assert`, `$fatal` |
| 랜덤 테스트 | `$random` 등 | `$urandom_range()` 등 |

SystemVerilog는 기존 Verilog 문법을 지원하면서 자료형, 함수, Task, Assertion 등의 기능을 추가하여 검증 코드를 구조화할 수 있다.

#### 4.2.2 typedef enum - Opcode 정의

```systemverilog
typedef enum logic [2:0] {
    OP_DEFAULT0 = 3'b000,
    OP_ADD      = 3'b001,
    OP_SUB      = 3'b010,
    OP_MUL      = 3'b011,
    OP_AND      = 3'b100,
    OP_OR       = 3'b101,
    OP_XOR      = 3'b110,
    OP_DEFAULT7 = 3'b111
} opcode_t;

opcode_t opcode;
```

- `typedef`는 새로운 자료형 이름을 정의한다.
- `enum`은 여러 상수값을 열거형으로 정의한다.
- `logic [2:0]`은 Opcode의 비트 폭을 지정한다.
- `opcode_t`는 정의한 열거형 자료형이다.
- 일반 비트 벡터와 달리 열거형은 타입 검사를 제공하며, 정수에서 변환할 때 명시적 캐스팅이 필요할 수 있다.

#### 4.2.3 function automatic - Reference Model

```systemverilog
function automatic logic [15:0] golden_alu(
    input logic [7:0] x,
    input logic [7:0] y,
    input opcode_t op
);
```

- `function`은 입력값을 이용해 결과를 계산하고 반환한다.
- `automatic`은 호출마다 독립적인 지역 변수를 사용하도록 한다.
- `golden_alu()`는 ALU의 예상 결과를 계산하는 Reference Model 역할을 한다.
- `function` 내부에는 `#1`과 같은 시간 지연을 사용할 수 없다.

```systemverilog
expected = golden_alu(in_a, in_b, in_op);
```

기존 Verilog TB에서는 `always` 블록에서 예상 결과를 계산했지만, SystemVerilog에서는 `function`으로 분리하여 재사용할 수 있다.

#### 4.2.4 task automatic - 반복 검증

```systemverilog
task automatic check_alu(
    input logic [7:0] in_a,
    input logic [7:0] in_b,
    input opcode_t in_op
);
```

- `task`는 여러 테스트 절차를 하나로 묶어 재사용하는 기능이다.
- 입력 인가, 예상 결과 계산, 출력 비교, 로그 출력을 하나의 Task에서 수행한다.
- `function`과 달리 `#1`과 같은 시간 지연을 사용할 수 있다.

**Task 실행 과정**

1. `a`, `b`, `opcode` 입력 설정
2. `golden_alu()`로 예상 결과 계산
3. `#1` 지연 후 DUT 출력 확인
4. Verilog와 SystemVerilog ALU 출력 비교
5. 실제 출력과 예상 결과 비교
6. PASS/FAIL 출력 및 테스트 카운트 갱신

```systemverilog
check_alu(8'hFF, 8'h01, OP_ADD);
check_alu(8'h03, 8'h05, OP_SUB);
```

이처럼 Task를 호출하면 테스트 절차를 반복 작성하지 않아도 된다.

#### 4.2.5 assert - 자동 검증

```systemverilog
assert (result_v === result_sv)
else
    $fatal(1, "Verilog/SV MISMATCH");

assert (result_sv === expected)
else
    $fatal(1, "WRONG RESULT");
```

- `assert`는 지정한 조건이 만족되는지 검사한다.
- `===`는 X/Z 상태까지 구분하여 비교하는 연산자이다.
- `$fatal`은 검증 실패 메시지를 출력하고 시뮬레이션을 종료한다.
- `result_v`와 `result_sv`가 같은지 먼저 확인하고, 이후 예상 결과와 비교한다.

**주의:** 두 DUT의 결과가 같더라도 둘 다 잘못 계산했을 가능성이 있으므로 Expected Value와의 비교도 필요하다.

#### 4.2.6 Random Test - 100개 자동 검증

```systemverilog
for (int i = 0; i < 100; i++) begin
    check_alu(
        $urandom_range(0, 255),
        $urandom_range(0, 255),
        opcode_t'(i % 8)
    );
end
```

- `$urandom_range(0, 255)`는 0~255 범위의 랜덤 값을 생성한다.
- `for` 문으로 총 100개 테스트를 수행한다.
- `i % 8`은 Opcode 0~7을 순환하도록 한다.
- `opcode_t'(...)`는 정수값을 `opcode_t` 열거형으로 변환한다.
- 모든 Opcode를 최소 12번씩 테스트하며, 입력 `a`, `b`는 랜덤으로 생성한다.

#### 4.2.7 전체 검증 구조

```text
Directed Test (8개)
        +
Random Test (100개)
        |
        v
  check_alu() Task
        |
        +----> 입력값 인가
        |
        +----> golden_alu() 함수
        |         |
        |         v
        |     Expected Value
        |
        +----> alu8.v
        |         |
        |         v
        |      result_v
        |
        +----> alu8_sv.sv
                  |
                  v
               result_sv
                  |
                  v
          Assertion 검증
                  |
                  v
             PASS / FAIL
```

#### 4.2.8 검증 항목 및 결과

- [x] ADD/SUB/MUL/AND/OR/XOR 6개 연산 검증
- [x] 미사용 Opcode `000`, `111` 검증
- [x] Verilog와 SystemVerilog 출력 비교
- [ ] Expected Value 비교
- [x] 랜덤 테스트 100개 실행
- [x] 전체 108개 테스트 PASS 확인

**예상 최종 로그**

```text
ALL TESTS PASSED: 108
```

#### 4.2.9 학습 내용 정리

- SystemVerilog의 `enum`을 사용하면 Opcode나 FSM 상태를 자료형으로 정의할 수 있다.
- `function`으로 예상 결과 계산을 분리하여 검증 코드를 재사용할 수 있다.
- `task`는 시간 지연을 포함한 테스트 절차를 하나로 묶는 데 적합하다.
- `always_comb` 내부에는 시간 지연을 사용할 수 없지만, TB의 `task`에서는 사용할 수 있다.
- `assert`를 이용해 출력 불일치를 자동으로 검출할 수 있다.
- 랜덤 테스트와 Reference Model을 활용하면 수작업으로 파형을 확인하는 것보다 많은 입력 조합을 효율적으로 검증할 수 있다.
- 이번 검증 구조는 향후 Scoreboard, Functional Coverage, UVM 학습의 기초가 된다.

### 4.3 Vivado Synthesis
- [x] Synthesis 정상 완료
- [x] Utilization Report 저장
- [ ] Latch 관련 경고 확인
- [x] 합성 결과 분석

## 5. 언어별 연계 학습

### Verilog
- `alu8.v` 구현
- `case`, 산술 및 비트 연산자 활용

### SystemVerilog
- `tb_alu8.sv` 구현
- `logic`, `task`, `assert` 학습

### Python
- 이번 Day06에서는 추가 필수 실습 없음
- Day05의 Shift-Add Python Reference Model 복습만 진행

### C
- ARM 학습 단계에서 진행

## 6. 검증 결과

| 검증 항목 | 예상 결과 | 실제 결과 |
|---|---|---|
| ADD | 8비트 덧셈 결과 | 확인 |
| SUB | 8비트 뺄셈 결과 | 확인 |
| AND | 비트 AND | 확인 |
| OR | 비트 OR | 확인 |
| XOR | 비트 XOR | 확인 |
| 미사용 Opcode | 0 | 확인 |
| 랜덤 테스트 100개 | 전체 PASS | 확인 |
| Synthesis | 정상 완료, Latch 없음 | 확인 |

**시뮬레이션 파형:**
<img width="1040" height="193" alt="image" src="https://github.com/user-attachments/assets/087dde45-f94b-42a9-889c-8b44beeb42e3" />

**PASS/FAIL 로그:**
<img width="202" height="50" alt="image" src="https://github.com/user-attachments/assets/fc414b3e-3075-4016-9004-f5e2b0ef6cec" />

**합성 리포트:**
<img width="555" height="176" alt="image" src="https://github.com/user-attachments/assets/16d85faf-3df5-4579-92c0-5b378a72f5fc" />

<img width="498" height="89" alt="image" src="https://github.com/user-attachments/assets/fabd0d3d-8c05-45ba-a4e3-a645f25e7154" />

## 7. 에러 및 해결

- **발생한 문제:**
  - SystemVerilog ALU에서 `opcode` 중복 선언으로 Synthesis Warning 발생
  - 중복 선언을 수정하는 과정에서 `opcode` 입력 포트를 제거하여 `Net opcode does not have driver` Warning 발생
  - Testbench에서 `always_comb` 내부에 시간 지연 및 결과 검증을 작성하려고 했으나 사용 방식에 문제가 있었음

- **원인:**
  - `input logic [2:0] opcode`와 `opcode_t opcode`를 같은 모듈에 중복 선언함
  - `enum`으로 내부 변수를 선언하는 것과 외부 입력 포트를 선언하는 것의 차이를 정확히 이해하지 못함
  - `always_comb`는 조합논리 전용 블록이므로 `#1`과 같은 시간 지연을 사용할 수 없으며, DUT 출력이 갱신되기 전에 비교하면 Race Condition이 발생할 수 있음

- **수정한 RTL/SV/TB 코드:**
  - ALU의 `input logic [2:0] opcode`를 유지하고 내부의 중복 선언 제거
  - `typedef enum logic [2:0]`으로 Opcode 상수를 정의하여 `case` 문에서 사용
  - 예상 결과 계산은 `function automatic`으로 분리
  - 입력 인가, 시간 지연, 결과 비교를 `task automatic`으로 구성
  - `assert`와 `$fatal`을 이용하여 Verilog/SV 출력 및 Expected Value 비교

- **변경 전후 결과:**
  - `opcode` 선언 문제의 원인과 수정 방법을 파악함
  - 입력 포트와 내부 변수가 서로 다른 역할을 한다는 점을 이해함
  - 기존의 단순 파형 확인 방식에서 자동 PASS/FAIL 검증 구조로 개선함
  - 병렬 합성 관련 `Synth 8-7080` Warning은 RTL 기능 오류와 직접적인 관련이 없음을 확인함

## 8. 학습 내용 및 느낀 점

- **새롭게 이해한 개념:**
  - `case`와 `default`를 활용하여 ADD, SUB, MUL, AND, OR, XOR 연산을 수행하는 8비트 ALU 구현
  - Signed/Unsigned 자료형에 따른 연산 결과 해석 및 출력 비트 폭의 중요성
  - SystemVerilog의 `logic`, `always_comb`, `typedef enum` 사용법
  - `function automatic`을 이용한 Reference Model과 `task automatic`을 이용한 테스트 절차 구성
  - `assert`, `$fatal`, `$urandom_range()`를 이용한 자동 검증 방법
  - Vivado Synthesis Warning을 분석하여 RTL 선언 및 연결 문제를 확인하는 방법

- **기존에 잘못 알고 있던 부분:**
  - `enum` 변수를 선언하면 외부 입력 포트 역할까지 수행한다고 생각했으나, 입력 포트는 별도로 연결되어야 한다는 점을 이해함
  - SystemVerilog가 Verilog와 문법만 조금 다른 언어라고 생각했으나, `enum`, `function`, `task`, `assert` 등 검증 기능이 크게 확장되어 있다는 점을 알게 됨

- **추가로 공부할 내용:**
  - Signed/Unsigned 연산 및 Overflow와 Carry 처리
  - `typedef enum`과 `package`를 활용한 RTL 구조화
  - SystemVerilog Assertion과 Functional Coverage
  - ALU의 LUT/DSP Utilization 및 Timing Report 분석
  - Python Reference Model을 활용한 RTL 검증 자동화

## 9. 다음 학습에서 보완할 내용
- Carry와 Overflow 처리
- SystemVerilog 자동 검증 확장
- ALU 합성 자원 및 Timing 분석
- 다음 주차 학습 진행

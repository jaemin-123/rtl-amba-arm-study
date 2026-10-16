# Week 01 - Day 03: Verilog HDL 연산자

## 1. 학습 목표
- [ ] Verilog 연산자의 종류와 연산자 우선순위 이해
- [ ] 산술, 관계, 등가, 논리, 비트 연산자 이해
- [ ] 축약(Reduction) 연산자의 동작 이해
- [ ] 논리 Shift와 산술 Shift의 차이 이해
- [ ] 결합 및 반복 연산자 이해
- [ ] Vivado에서 연산자 관련 RTL 및 Testbench 작성

## 2. 공부 자료
- **강의:** [KOCW - Verilog HDL 및 Vivado 실습](http://www.kocw.net/home/search/kemView.do?kemId=1428200)
- **수강 범위:** Verilog HDL 연산자
- **교재/참고 자료:** 강의 PDF - Verilog HDL 연산자 (2.2절)
- **개발 환경:** Vivado 2022.2 / Verilog HDL

## 3. 학습 내용 정리

### 3.1 연산자의 종류

| 구분 | 연산자 | 설명 |
|---|---|---|
| 산술 | `+`, `-`, `*`, `/`, `%`, `**` | 산술 연산 |
| 관계 | `<`, `>`, `<=`, `>=` | 크기 비교 |
| 등가 | `==`, `!=`, `===`, `!==` | 값 비교 |
| 논리 | `&&`, `||`, `!` | 논리적 참/거짓 판단 |
| 비트 | `&`, `|`, `^`, `~`, `~^` | 각 비트에 대한 연산 |
| 축약 | `&`, `~&`, `|`, `~|`, `^`, `~^` | 여러 비트를 1비트로 축약 |
| Shift | `<<`, `>>`, `<<<`, `>>>` | 비트 이동 |
| 조건 | `?:` | 조건에 따라 값 선택 |
| 결합 및 반복 | `{}`, `{{}}` | 비트 결합 및 반복 |

### 3.2 등가 연산자

- `==`: 논리적 등가 비교. X/Z가 포함된 경우 결과가 X가 될 수 있음
- `===`: X/Z까지 포함하여 각 비트의 일치 여부 판단

```verilog
reg [3:0] a, b;
reg eq1, eq2;

initial begin
    a = 4'b1x0z;
    b = 4'b1x0z;

    eq1 = (a == b);
    eq2 = (a === b);
end
```

**예상 결과**
- `eq1 = 1'bx`
- `eq2 = 1'b1`

### 3.3 논리 연산과 비트 연산

- 논리 연산자는 피연산자를 참/거짓으로 판단하여 1비트 결과 생성
- 비트 연산자는 각각의 비트에 연산을 적용

```verilog
wire [3:0] a = 4'b1010;
wire [3:0] b = 4'b1100;

wire logic_result = a && b;
wire [3:0] bit_result = a & b;
```

**예상 결과**
- `logic_result = 1'b1`
- `bit_result = 4'b1000`

### 3.4 축약(Reduction) 연산자

- 벡터의 각 비트에 동일한 연산을 적용하여 1비트 결과 생성
- AND, OR, XOR, NAND, NOR, XNOR 연산 가능

```verilog
wire [3:0] a;
wire y1, y2;

assign y1 = ~(a[0] & a[1] & a[2] & a[3]);
assign y2 = ~&a;
```

두 방식의 결과는 동일함.

### 3.5 Shift 연산자

- `<<`, `>>`: 논리 Shift
- `<<<`, `>>>`: 산술 Shift
- `>>>`는 좌측 피연산자가 signed인 경우 부호 비트를 유지하면서 오른쪽으로 이동

```verilog
wire signed [7:0] data1 = 8'b1010_1100;
wire        [7:0] data2 = 8'b1000_1111;

wire [7:0] out1 = data1 >>> 2;
wire [7:0] out2 = data2 >>> 2;
```

**예상 결과**
- `out1 = 8'b1110_1011`
- `out2 = 8'b0010_0011`

### 3.6 결합 연산자와 Carry Bit

- `{}`를 이용하여 여러 신호를 하나의 벡터로 결합
- 덧셈 결과에서 Carry Bit와 Sum을 분리할 수 있음

```verilog
wire [3:0] a, b;
wire [3:0] sum;
wire carry;

assign {carry, sum} = a + b;
```

예시 입력: `a = 4'b1111`, `b = 4'b0001`

**예상 결과**
- `sum = 4'b0000`
- `carry = 1'b1`

## 4. RTL 설계 및 실습

### 4.1 Equality 연산자 비교
- **목표:** `==`와 `===`의 차이 확인
- **파일:** `tb/tb_equality.v`
- **검증:** X/Z가 포함된 입력에 대한 비교 결과

### 4.2 Reduction 연산자
- **목표:** 비트 연산과 축약 연산으로 구현한 NAND 출력 비교
- **RTL 파일:** `rtl/reduction_op.v`
- **TB 파일:** `tb/tb_reduction.v`
- **검증:** 4비트 전체 16개 입력 조합

### 4.3 Signed / Unsigned Shift
- **목표:** 논리 Shift와 산술 Shift의 결과 비교
- **RTL 파일:** `rtl/shift_op.v`
- **TB 파일:** `tb/tb_shift.v`
- **검증:** signed 여부에 따른 MSB 처리 비교

### 4.4 Carry Bit 확인
- **목표:** 결합 연산자를 사용하여 Carry Bit 확인
- **RTL 파일:** `rtl/adder_width.v`
- **TB 파일:** `tb/tb_adder_width.v`
- **검증:** 덧셈 결과의 비트 폭과 Carry 확인

## 5. 검증 결과

### 테스트 항목
- [ ] Equality 연산자의 X/Z 비교 결과 확인
- [ ] 비트 연산과 논리 연산 차이 확인
- [ ] Reduction NAND 결과 비교
- [ ] Signed / Unsigned Shift 비교
- [ ] 덧셈 Carry Bit 정상 출력 확인
- [ ] 예상 결과와 실제 시뮬레이션 결과 비교

### 예상 결과 / 실제 결과

| 테스트 | 예상 결과 | 실제 결과 |
|---|---|---|
| `==` / `===` | X / 1 | 미확인 |
| Reduction NAND | 두 출력 일치 | 미확인 |
| Signed `>>> 2` | `1110_1011` | 미확인 |
| Unsigned `>>> 2` | `0010_0011` | 미확인 |
| `15 + 1` | Carry=1, Sum=0 | 미확인 |

### 시뮬레이션 파형 및 로그
- Equality:
- Reduction:
- Shift:
- Carry Bit:

## 6. 에러 및 해결
- **발생한 문제:**
- **원인:**
- **수정한 RTL 코드:**
- **변경 전후 결과:**

## 7. 학습 내용 및 느낀 점
- **새롭게 이해한 개념:**
- **기존에 잘못 알고 있던 부분:**
- **추가로 공부할 내용:**

## 8. 다음 학습에서 보완할 것
- 조합논리회로의 다양한 모델링 방식
- `assign`과 `always @(*)`의 차이
- MUX 및 ALU 설계에서 연산자 활용

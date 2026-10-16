# Week 01 - Day 03: Verilog HDL 연산자

## 1. 학습 목표
- [x] Verilog 연산자의 종류와 연산자 우선순위 이해
- [x] 산술, 관계, 등가, 논리, 비트 연산자 이해
- [x] 축약(Reduction) 연산자의 동작 이해
- [x] 논리 Shift와 산술 Shift의 차이 이해
- [x] 결합 및 반복 연산자 이해
- [x] Vivado에서 연산자 관련 RTL 및 Testbench 작성

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
| 논리 | `&&`, `\|\|`, `!` | 논리적 참/거짓 판단 |
| 비트 | `&`, `\|`, `^`, `~`, `~^` | 각 비트에 대한 연산 |
| 축약 | `&`, `~&`, `\|`, `~\|`, `^`, `~^` | 여러 비트를 1비트로 축약 |
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
- [x] Equality 연산자의 X/Z 비교 결과 확인
- [x] 비트 연산과 논리 연산 차이 확인
- [x] Reduction NAND 결과 비교
- [x] Signed / Unsigned Shift 비교
- [x] 덧셈 Carry Bit 정상 출력 확인
      
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
  <img width="1038" height="145" alt="image" src="https://github.com/user-attachments/assets/5f5d9160-4002-4cba-a7be-9ccad42418ab" />

- Reduction:
  <img width="1037" height="217" alt="image" src="https://github.com/user-attachments/assets/b332e3d4-68ba-4038-99f2-8bdcd6ec6b97" />

- Shift:
  <img width="1034" height="192" alt="image" src="https://github.com/user-attachments/assets/75627003-7e46-4bbf-906a-2aca0dad0418" />

- Carry Bit:
  <img width="1038" height="145" alt="image" src="https://github.com/user-attachments/assets/5e052ca3-78a0-4c02-acfe-6cddfed4a583" />

## 6. 에러 및 해결
- **발생한 문제:** Reduction 연산자 Testbench에서 입력 `a`만 변경하여 Logical AND(`&&`)와 Bitwise AND(`&`)의 다양한 출력 결과를 확인하기 어려웠음
- **원인:** `logic_result`와 `bit_result`는 `b`, `c`에 의해 결정되지만, 초기 Testbench에서는 두 신호를 고정하여 출력이 변하지 않았음
- **수정한 TB 코드:** `a`뿐만 아니라 `b`, `c`도 변경하여 다양한 연산 결과를 검증

```verilog
initial begin
    a = 4'h5; b = 4'b1010; c = 4'b1100;
    #10 a = 4'ha; b = 4'b0000;
    #10 a = 4'hc; b = 4'b1111;
    #10 a = 4'h2; c = 4'b0000;
    #10 a = 4'hf; c = 4'b1111;
    #10 $finish;
end
```

- **변경 전후 결과:** 기존에는 `logic_result`와 `bit_result`의 출력이 일정했지만, 수정 후 입력 조합에 따른 Logical AND와 Bitwise AND의 출력 변화를 확인할 수 있었음

## 7. 학습 내용 및 느낀 점
- **새롭게 이해한 개념:**
  - **Equality:** `==`, `!=`는 일반적인 값 비교이며, `===`, `!==`는 `X`, `Z`까지 포함하여 비교한다는 점
  - **Reduction:** `&&`는 다중 비트 입력을 각각 참/거짓으로 판단하여 1bit 결과를 출력하지만, `&`는 비트별 AND 연산을 수행한다는 점. 또한 `~&`를 통해 벡터 전체에 대한 Reduction NAND 연산이 가능하다는 점
  - **Shift:** `>>`는 왼쪽 빈자리를 0으로 채우지만, `>>>`는 입력의 Signed 여부에 따라 부호 확장이 달라진다는 점
  - **Carry Bit:** `{carry, sum}`과 Concatenation 연산자를 활용하여 덧셈 결과의 Carry-out과 Sum을 분리할 수 있다는 점

- **기존에 잘못 알고 있던 부분:**
  - `&&`는 주로 1bit 신호나 비교 조건에만 사용한다고 생각했으나, 다중 비트 벡터도 논리적 참/거짓으로 평가할 수 있음을 이해함
  - `>>>`는 항상 부호 확장을 수행한다고 생각할 수 있지만, Unsigned 입력에서는 `>>`와 동일하게 0으로 채워진다는 점을 확인함

- **추가로 공부할 내용:**
  - Equality 연산에서 `X`, `Z`가 포함된 경우의 비교 결과
  - Signed/Unsigned 연산 및 비트 폭에 따른 연산 결과 차이
  - Carry-out과 Signed Overflow의 차이 및 ALU Flag 구현 방법
  - ```
    - **Carry Flag (CF):** Unsigned 덧셈에서 최상위 비트 밖으로 Carry가 발생했는지 판단
    - **Overflow Flag (OF):** Signed 덧셈에서 표현 가능한 수치 범위를 초과했는지 판단
    - **차이점:** Carry는 비트 폭을 초과하는 자리올림을 기준으로, Overflow는 Signed 연산 결과의 부호 및 표현 범위를 기준으로 판단한다.
    ```

## 8. 다음 학습에서 보완할 것
- 조합논리회로의 다양한 모델링 방식
- `assign`과 `always @(*)`의 차이
- MUX 및 ALU 설계에서 연산자 활용

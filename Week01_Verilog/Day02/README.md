# Week 01 - Day 02: Verilog 자료형과 연산자

## 1. 학습 목표
- [x] Verilog의 4가지 논리값 이해
- [x] Net과 Variable 자료형의 차이 이해
- [ ] wire, reg, tri, wand, wor의 특징 이해
- [x] Vector와 Array 선언 방식 이해
- [x] Parameter와 Parameter Overriding 이해
- [x] 강의 예제 RTL 작성 및 시뮬레이션

## 2. 공부 자료
- **강의:** [KOCW - Verilog HDL 및 Vivado 실습](http://www.kocw.net/home/search/kemView.do?kemId=1428200)
- **학습 주제:** Verilog HDL 자료형과 연산자
- **참고 자료:** 강의 PDF - 자료형과 연산자 (2.1절)
- **개발 환경:** Vivado 2022.2

## 3. 학습 내용 정리

### 3.1 Verilog 논리값

| 논리값 | 의미 |
|---|---|
| 0 | Logic Low |
| 1 | Logic High |
| x | Unknown |
| z | High Impedance |

- `x`: 초기화되지 않았거나 신호 충돌 등으로 값이 확정되지 않은 상태
- `z`: 신호가 구동되지 않는 High-Impedance 상태

### 3.2 Net과 Variable

**Net 자료형**
- 하드웨어 구성 요소 사이의 연결 표현
- `wire`, `tri`, `wand`, `wor` 등
- 일반적인 net은 값을 저장하지 않고 Driver에 의해 구동됨

**Variable 자료형**
- 절차적 할당문에서 사용
- `reg`, `integer`, `time`, `real` 등
- `reg`는 항상 Flip-Flop을 의미하는 것이 아니며 조합논리에서도 사용 가능

### 3.3 Vector와 Array

```verilog
wire [7:0] data;
reg [15:0] result;

reg [7:0] memory [0:255];
```

- Vector: 여러 비트로 이루어진 하나의 신호
- Array: 여러 요소로 구성된 자료구조
- Array는 RAM, ROM, Register File 모델링에 사용 가능

### 3.4 Parameter

```verilog
module example #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] a,
    output [WIDTH-1:0] y
);
    assign y = a;
endmodule
```

- Parameter를 이용하면 모듈의 비트 폭 등을 변경할 수 있음
- 모듈을 재사용할 때 유용함

## 4. RTL 실습

### 4.1 wand / wire 동작 비교
- **참고:** PDF 6페이지
- **파일:** `rtl/wand_ex.v`
- **목표:** 여러 Driver가 연결된 일반 wire와 wand의 시뮬레이션 결과 비교

### 4.2 D Flip-Flop과 MUX
- **참고:** PDF 7페이지
- **파일:** `rtl/dff.v`, `Day01_Basic_Combinational/rtl/mux2.v`
- **목표:** 순차회로와 조합회로에서 reg가 사용되는 방식 비교

### 4.3 Parameter Overriding
- **참고:** PDF 11페이지
- **파일:** `rtl/param_xnor.v`
- **목표:** 기본 Parameter와 변경된 Parameter의 출력 비트 폭 비교

## 5. 검증 결과

### 테스트 항목
- [x] wire와 wand의 다중 Driver 동작 비교
- [x] D Flip-Flop의 Clock Edge 동작 확인
- [x] Parameter WIDTH=8 동작 확인
- [x] Parameter WIDTH=4 동작 확인

### 시뮬레이션 결과
- Wand_ex:
  <img width="1032" height="225" alt="image" src="https://github.com/user-attachments/assets/a3ffba60-4616-4292-a1bf-2cef9eb2043f" />
  
- D Flip-Flop:
  <img width="1039" height="125" alt="image" src="https://github.com/user-attachments/assets/02781280-96ad-4a7a-b16c-74cd71564049" />

- Parameter:
  <img width="1037" height="192" alt="image" src="https://github.com/user-attachments/assets/dd673047-8a71-44f8-afce-d39ca824f5c0" />

## 6. 에러 및 해결
- **발생한 문제:**
- **원인:**
- **수정한 RTL 코드:**
- **변경 전후 결과:**

## 7. 학습 내용 및 느낀 점
- 새롭게 이해한 개념:
- 기존에 잘못 알고 있던 부분:
- 추가로 공부할 내용:

## 6. 에러 및 해결
- **발생한 문제:** DFF Testbench 작성 중 `forever`문 이후 입력 신호 `d`를 변경하는 코드가 정상적으로 실행되지 않는 구조
- **원인:** `forever`는 무한 반복문이므로 동일한 `initial` 블록에서 `forever` 이후에 작성된 코드는 실행되지 않음
- **수정한 TB 코드:** Clock 생성과 입력 Stimulus를 별도의 블록으로 분리

```verilog
always #5 clk = ~clk;

initial begin
    d = 0;
    #12 d = 1;
    #10 d = 0;
    #10 d = 1;
    #10 $finish;
end
```

- **변경 전후 결과:** `forever`를 이용한 기존 TB 구조를 수정하여 Clock 생성과 입력 신호 변경이 독립적으로 실행되도록 구성

## 7. 학습 내용 및 느낀 점
- 새롭게 이해한 개념: `wire`는 여러 Driver가 서로 다른 논리값을 구동할 때 `X(Unknown)`가 발생할 수 있지만, `wand`는 여러 Driver의 출력을 AND 연산하여 최종 값을 결정한다는 것을 이해함
- 기존에 잘못 알고 있던 부분: `always`문은 반드시 `@(*)`, `@(posedge clk)` 형태로 작성해야 한다고 생각했지만, `always #5`처럼 지연 제어문을 사용할 수도 있다는 것을 알게 됨. 또한 `forever`는 `always`와 달리 절차적 블록 내부에서 사용하는 무한 반복문임을 이해함
- 추가로 공부할 내용: `wor`, `tri` 등 다른 Net 자료형의 특성과 Multi-driver 발생 시 신호 처리 방식

## 8. 다음 학습에서 보완할 것
- Verilog 연산자와 연산 결과의 비트 폭
- signed / unsigned 연산 차이
- 조합논리회로 설계 및 검증

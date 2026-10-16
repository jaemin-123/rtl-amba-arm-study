# Week 01 - Day 01: Verilog 기초 조합회로

## 1. 학습 목표
- [x] Verilog Module 구조 이해
- [x] Input / Output / Wire 개념 이해
- [x] 2:1 MUX 설계 및 검증
- [x] Half Adder 설계 및 검증
- [x] Full Adder 설계 및 검증
- [x] Vivado Behavioral Simulation으로 동작 확인

## 2. 공부 자료
- **강의:** [KOCW Verilog HDL 및 Vivado 실습](http://www.kocw.net/home/search/kemView.do?kemId=1428200)
- **수강 범위:** 2~3차시
- **참고 자료:** 강의 PDF
- **개발 환경:** Vivado 2022.2

## 3. 설계 및 구현

### 3.1 2:1 Multiplexer
- 기능: sel 값에 따라 입력 A/B 중 하나 선택
- 설계 방식: if문과 case문 비교
  - 4:1 Multiplexer의 경우 rtl 합성시 if문이 path가 3부분으로 길어짐
- RTL 파일: `rtl/mux2.v`

### 3.2 Half Adder
- 기능: 두 개의 1비트 입력 덧셈
- Sum = A ^ B
- Carry = A & B
- RTL 파일: `rtl/half_adder.v`

### 3.3 Full Adder
- 기능: Carry-in을 포함한 세 개의 1비트 입력 덧셈
- Sum = A ^ B ^ Cin
- Cout = (A & B) | (Cin & (A ^ B))
- RTL 파일: `rtl/full_adder.v`

## 4. 검증 결과

### 테스트 항목
- [x] MUX2 전체 입력 조합 검증
- [x] Half Adder 전체 입력 조합 검증
- [x] Full Adder 전체 입력 조합 검증

### 시뮬레이션 결과
- <img width="1041" height="143" alt="image" src="https://github.com/user-attachments/assets/f1df9ef2-d470-430b-835a-0e4ce0c9551d" />
- <img width="1022" height="144" alt="image" src="https://github.com/user-attachments/assets/4a278b67-75ac-4d1d-bbac-8db45667f9e6" />
- <img width="1023" height="169" alt="image" src="https://github.com/user-attachments/assets/2b96451d-d3e7-46c4-baa5-c43b8bf8ec43" />

## 5. 에러 및 해결
- 발생한 문제:
- 원인:
- 수정 내용:
- 수정 전후 결과:

## 6. 학습 내용 정리
- Module과 Port 선언 방식
```verilog
module module_name (port_list);
    port 선언 (비트 크기) ex) input [1:0] a, b;
    reg 선언 (출력)
    wire 선언 (내부 선 연결)
    파라미터 선언

    하위 모듈 호출
    always, initial 문
    function, task 정의문 호출문 (아직 제대로 안배움)
    assign 문
endmodule
```
- 조합논리와 연속 할당(assign)
```text
조합논리 : 이벤트가 생겼을때 동작, always문 내부 순차 동작 ex) always @(sel or a or b) begin
연속 할당(assign) : 우변의 변화가 생겼을 때 좌변에 값 할당 ex) assign cout = a & b;
```
- reg, wire 사용
```text
reg : 값 저장하는 변수 ( always, inital 문 내부의 좌변에 오는 변수는 reg 타입 이여야 함 절차적 할당) Procedural assignment
wire : 물리적 연결선 (assign 구문 연속 할당) Continuous assignment
```

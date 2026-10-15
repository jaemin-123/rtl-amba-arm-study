# Week 01 - Day 01: Verilog 기초 조합회로

## 1. 학습 목표
- [ ] Verilog Module 구조 이해
- [ ] Input / Output / Wire 개념 이해
- [ ] 2:1 MUX 설계 및 검증
- [ ] Half Adder 설계 및 검증
- [ ] Full Adder 설계 및 검증
- [ ] Vivado Behavioral Simulation으로 동작 확인

## 2. 공부 자료
- **강의:** [KOCW Verilog HDL 및 Vivado 실습](http://www.kocw.net/home/search/kemView.do?kemId=1428200)
- **수강 범위:** 2~3차시
- **참고 자료:** 강의 PDF
- **개발 환경:** Vivado 2022.2

## 3. 설계 및 구현

### 3.1 2:1 Multiplexer
- 기능: sel 값에 따라 입력 A/B 중 하나 선택
- 설계 방식:
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
- [ ] MUX2 전체 입력 조합 검증 (8개)
- [ ] Half Adder 전체 입력 조합 검증 (4개)
- [ ] Full Adder 전체 입력 조합 검증 (8개)
- [ ] 예상 출력과 실제 출력 비교

### 시뮬레이션 결과
- MUX2:
- Half Adder:
- Full Adder:

### 파형
- `images/mux2_waveform.png`
- `images/half_adder_waveform.png`
- `images/full_adder_waveform.png`

## 5. 에러 및 해결
- 발생한 문제:
- 원인:
- 수정 내용:
- 수정 전후 결과:

## 6. 학습 내용 정리
- Module과 Port 선언 방식
- 조합논리와 연속 할당(assign)
- XOR, AND, OR 연산자의 역할
- Testbench를 통한 전체 입력 조합 검증

## 7. 다음 학습
- Verilog 자료형 및 연산자
- Vector와 Bit Width
- Blocking / Nonblocking Assignment 기초

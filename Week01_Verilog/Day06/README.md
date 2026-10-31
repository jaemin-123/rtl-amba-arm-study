# Week 01 - Day 06: 8-bit ALU 설계 및 자동 검증

## 1. 학습 목표
- [ ] Day01~Day05 Verilog 핵심 문법 복습
- [ ] `case` 문을 이용한 8-bit ALU 구현
- [ ] ADD, SUB, AND, OR, XOR 5개 연산 구현
- [ ] 미사용 Opcode에 대한 기본 출력 처리
- [ ] SystemVerilog Testbench의 `task`, `assert` 활용
- [ ] 랜덤 입력 100개 자동 검증
- [ ] Vivado Synthesis 및 Utilization Report 확인
- [ ] Latch 추론 여부 확인

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

### 4.2 SystemVerilog Testbench
- **TB:** `tb/tb_alu8.sv`
- **목표:** 직접 지정한 입력과 랜덤 입력 자동 검증

검증 항목:
- [ ] 5개 Opcode 정상 동작
- [ ] 0, 최대값 등 경계값 확인
- [ ] ADD/SUB 결과의 8비트 절단 동작 확인
- [ ] 미사용 Opcode 결과 확인
- [ ] 랜덤 테스트 100개 PASS 확인

### 4.3 Vivado Synthesis
- [ ] Synthesis 정상 완료
- [ ] Utilization Report 저장
- [ ] Latch 관련 경고 확인
- [ ] 합성 결과 분석

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
| ADD | 8비트 덧셈 결과 | 미확인 |
| SUB | 8비트 뺄셈 결과 | 미확인 |
| AND | 비트 AND | 미확인 |
| OR | 비트 OR | 미확인 |
| XOR | 비트 XOR | 미확인 |
| 미사용 Opcode | 0 | 미확인 |
| 랜덤 테스트 100개 | 전체 PASS | 미확인 |
| Synthesis | 정상 완료, Latch 없음 | 미확인 |

**시뮬레이션 파형:**

**PASS/FAIL 로그:**

**합성 리포트:**

## 7. 에러 및 해결
- **발생한 문제:**
- **원인:**
- **수정한 RTL/SV/TB 코드:**
- **변경 전후 결과:**

## 8. 학습 내용 및 느낀 점
- **새롭게 이해한 개념:**
- **기존에 잘못 알고 있던 부분:**
- **추가로 공부할 내용:**

## 9. 다음 학습에서 보완할 내용
- Carry와 Overflow 처리
- SystemVerilog 자동 검증 확장
- ALU 합성 자원 및 Timing 분석
- 다음 주차 학습 진행

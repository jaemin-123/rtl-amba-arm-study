# RTL → AMBA → ARM Cortex-M7 | 12주 학습 체크리스트

> **목표:** Verilog RTL 설계 → AMBA APB/AXI 인터페이스 → ARM Architecture/Software → Cortex-M7 → ARM(PS)+FPGA(PL) 통합  
> **학습량:** 12주 × 주 6일 = **72일**, 하루 **약 3시간** (강의 50분 + 참고자료 30분 + 실습 80분 + 정리 20분)  
> **체크 방법:** 그날의 **강의·자료 학습 + 실습 + 완료 기준**을 모두 달성한 뒤 `- [ ]`을 `- [x]`로 변경  
> **환경:** Vivado 2022.2, XSIM, Zybo Z7-20(ARM Cortex-A9), 기존 STM32 개발환경. **Cortex-M7 보드는 STM32H7 별도 필요**  
> **언어:** 한국어 강의·한글 학습 노트 중심. APB/AXI 사양 및 Cortex-M7의 일부 공식 자료는 필요한 절만 번역해 사용

## 📍 진행 현황

| 구간 | 주차 | 목표 | 상태 |
|---|---|---|---|
| Verilog RTL | 1~3주 | ALU, UART RX, 동기 FIFO + Testbench | ⬜ |
| AMBA Bus | 4~6주 | APB GPIO, AXI4-Lite IP, AXI Stream, Zybo 통합 | ⬜ |
| ARM Architecture | 7~8주 | ARM 명령어, Pipeline, Cache, MMU/MPU | ⬜ |
| ARM Software | 9~10주 | Bare-metal, CMSIS, Interrupt, UART DMA | ⬜ |
| Cortex-M7 | 11주 | Cache, TCM, MPU, DMA 일관성 | ⬜ |
| 최종 프로젝트 | 12주 | ARM C 제어 + AXI4-Lite RTL 가속기 | ⬜ |

## 📚 강의·교재 링크

- **A — 신경욱 교수 「HDL설계 - Verilog HDL 및 Vivado 실습」** (무료, KOCW): https://www.kocw.net/home/search/kemView.do?kemId=1428200
- **B — 이용환 교수 「SoC 구조 및 설계」** (무료, KOCW): https://www.kocw.net/home/search/kemView.do?kemId=1352183
- **C — 한태희 교수 「SOC구조」** (무료, KOCW): https://www.kocw.net/home/search/kemView.do?kemId=1347233
- **D — 설계독학맛비 「실전 Verilog HDL Season 2 (AMBA AXI4 완전정복)」** (유료, 인프런/선택): https://www.inflearn.com/course/설계독학맛비-실전-verilog-hdl-part2
- **책 — 신경욱 《Verilog HDL 설계》** (한글, 한빛아카데미): https://www.yes24.com/product/goods/119775568
- **Arm AMBA 사양** (영문 원문, 번역 보조): https://developer.arm.com/Architectures/AMBA
- **ST STM32 교육** (영문 공식 교육, 번역 보조): https://www.st.com/content/st_com/en/support/learning/stm32-education/stm32-online-training.html
- **ST STM32H7 교육** (영문 공식 교육, 번역 보조): https://www.st.com/content/st_com/en/support/learning/stm32-education/stm32-online-training/stm32h7-online-training.html

> **수강 번호 주의:** KOCW의 문서/영상 혼합 차시와 웹 화면 표기가 달라질 수 있어 **강의 제목/주제**를 우선 표시했어. D의 4~7강은 공개 목차에 나온 번호이고, 다른 섹션은 이름으로 찾도록 작성했어. 교재 CH는 판본별 목차를 확인하고 같은 주제의 장으로 조정하면 돼. 유료 D를 결제하지 않아도 진행 가능하도록 무료 대체 실습을 포함했어.

> **하드웨어 주의:** 6·12주차는 **Zybo의 Cortex-A9**을 이용한 ARM C ↔ FPGA RTL 통합이고, 11주차는 **STM32H7의 Cortex-M7** 별도 실습이야. STM32H7 보드가 없으면 11주차는 자료/예제 분석으로 먼저 진행하고 측정 실습은 보류해.

---

## ✅ 날짜별 실행 체크리스트

### Week 01 — Verilog 기초 / 조합논리

**사용 자료:** KOCW A 및 《Verilog HDL 설계》 CH1·2·4·5·10

- [ ] **Day 01 (주 1 / 1일차)** — **학습:** A 소개·개요 1~2 차시 / 책 CH1  
  **실습:** Vivado 프로젝트 생성, `mux2.v` 작성  
  **완료 기준:** MUX 0/1 선택 파형 저장
- [ ] **Day 02 (주 1 / 2일차)** — **학습:** A 자료형 강의 / CH2 자료형  
  **실습:** `wire/reg/logic`와 벡터 폭 예제 `types.v`  
  **완료 기준:** 비트폭 8/16과 signed 차이 기록
- [ ] **Day 03 (주 1 / 3일차)** — **학습:** A 연산자 강의 / CH2 연산자  
  **실습:** `operators.v` 산술·논리·비트 연산, 8비트 overflow 시험  
  **완료 기준:** 5종 이상의 연산 결과 비교
- [ ] **Day 04 (주 1 / 4일차)** — **학습:** A 조합회로 모델링의 assign/always 부분 / CH4  
  **실습:** `mux41.v`, `decoder.v` 구현  
  **완료 기준:** 모든 선택지 및 디코더 출력 검증
- [ ] **Day 05 (주 1 / 5일차)** — **학습:** A 행위수준 모델링 if/case 부분 / CH5  
  **실습:** `alu8.v` ADD/SUB/AND/OR/XOR 구현  
  **완료 기준:** opcode 5개 정상 동작
- [ ] **Day 06 (주 1 / 6일차)** — **학습:** CH10 테스트벤치·복습  
  **실습:** `tb_alu8.v` 자동 비교 100개, 합성 리포트 저장  
  **완료 기준:** PASS와 래치 없음 확인

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week01/README.md`에 기록.

### Week 02 — 순차논리 / FSM / UART

**사용 자료:** KOCW A 순차회로 모델링 1~3 및 책 CH11·13

- [ ] **Day 07 (주 2 / 1일차)** — **학습:** A 순차회로 모델링 (1) / CH11 FF  
  **실습:** `dff.v`, `latch_bad.v` 비교  
  **완료 기준:** Latch 추론 조건 설명
- [ ] **Day 08 (주 2 / 2일차)** — **학습:** A 순차회로 모델링 (2) / CH11 reset  
  **실습:** `counter.v` 동기/비동기 reset 구현  
  **완료 기준:** reset 시퀀스 통과
- [ ] **Day 09 (주 2 / 3일차)** — **학습:** A 순차회로 모델링 (3) / CH11 shift  
  **실습:** `shift_reg.v` 및 enable 제어  
  **완료 기준:** 파형으로 클록별 변화 확인
- [ ] **Day 10 (주 2 / 4일차)** — **학습:** CH11 FSM / 강의 FSM 관련 차시  
  **실습:** UART RX IDLE/START/DATA/STOP 상태도  
  **완료 기준:** 상태전이표 README 첨부
- [ ] **Day 11 (주 2 / 5일차)** — **학습:** CH11 UART 순차회로 복습  
  **실습:** `uart_rx.v` 8N1 RX 구현  
  **완료 기준:** 1바이트 수신 성공
- [ ] **Day 12 (주 2 / 6일차)** — **학습:** CH13 Vivado 합성·타이밍 관련 차시  
  **실습:** `tb_uart_rx.v` 오동작/리셋 테스트 및 합성  
  **완료 기준:** 정상/오류 case 결과 기록

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week02/README.md`에 기록.

### Week 03 — FIFO / 검증 자동화

**사용 자료:** KOCW A 구조 모델링·시뮬레이션 관련 차시, 책 CH6·7·9

- [ ] **Day 13 (주 3 / 1일차)** — **학습:** CH6 모듈/parameter  
  **실습:** 동기 FIFO 포트·parameter 정의  
  **완료 기준:** 폭/깊이 변경 가능
- [ ] **Day 14 (주 3 / 2일차)** — **학습:** CH7 task/function  
  **실습:** `tb_fifo.sv` push/pop 태스크 작성  
  **완료 기준:** 태스크로 8개 데이터 기록
- [ ] **Day 15 (주 3 / 3일차)** — **학습:** CH9 시스템 태스크·검증 코드  
  **실습:** `$fatal`/`$display`와 scoreboard  
  **완료 기준:** 의도적 오류 감지
- [ ] **Day 16 (주 3 / 4일차)** — **학습:** FIFO pointer/full/empty 자체 노트  
  **실습:** `fifo_sync.sv` read/write pointer 구현  
  **완료 기준:** full/empty 전환 정확
- [ ] **Day 17 (주 3 / 5일차)** — **학습:** FIFO 동시 읽기·쓰기 이론  
  **실습:** 연속 100회 랜덤 접근, 동시 R/W 검증  
  **완료 기준:** 값 손실/중복 없음
- [ ] **Day 18 (주 3 / 6일차)** — **학습:** Vivado 합성/타이밍 강의 복습  
  **실습:** FIFO 깊이 8/16별 LUT/FF 보고서 비교  
  **완료 기준:** 결과 표+회고 작성

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week03/README.md`에 기록.

### Week 04 — SoC 개념 / AMBA APB

**사용 자료:** KOCW B ‘SoC개념’, ‘AMBA 2.0 버스’; KOCW C SoC 설계 흐름

- [ ] **Day 19 (주 4 / 1일차)** — **학습:** B ‘SoC개념’ + C SoC Design Flow 관련 차시  
  **실습:** CPU–Interconnect–Memory–Peripheral 블록도  
  **완료 기준:** 버스 master/slave 식별
- [ ] **Day 20 (주 4 / 2일차)** — **학습:** B ‘AMBA 2.0 버스’ 강의  
  **실습:** AHB/APB와 AXI/Lite/Stream 비교표  
  **완료 기준:** 각 버스 용도 한 줄 설명
- [ ] **Day 21 (주 4 / 3일차)** — **학습:** Arm APB 공식 사양의 신호/전송 섹션(번역 활용)  
  **실습:** PSEL/PENABLE/PREADY/PSLVERR 파형 직접 작성  
  **완료 기준:** SETUP/ACCESS 구별
- [ ] **Day 22 (주 4 / 4일차)** — **학습:** APB wait-state·read/write 부분  
  **실습:** `apb_master_bfm.sv`와 wait-state 시퀀스  
  **완료 기준:** PREADY=0에서 제어 유지
- [ ] **Day 23 (주 4 / 5일차)** — **학습:** APB address decode + GPIO 레지스터맵  
  **실습:** `apb_gpio.v` GPIO_OUT/IN/DIR  
  **완료 기준:** 3개 주소 접근 성공
- [ ] **Day 24 (주 4 / 6일차)** — **학습:** APB 검증·오류 상황 복습  
  **실습:** `tb_apb_gpio.sv` 전 시나리오, README  
  **완료 기준:** read/write/wait PASS

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week04/README.md`에 기록.

### Week 05 — Valid/Ready / AXI4-Lite

**사용 자료:** 인프런 D 4~7강 + AXI 이론/AXI4-Lite 섹션(선택 유료)

- [ ] **Day 25 (주 5 / 1일차)** — **학습:** D 4~5강: valid-ready 이론·실습  
  **실습:** `rv_source.sv`/`rv_sink.sv`  
  **완료 기준:** 전송 조건 valid && ready 설명
- [ ] **Day 26 (주 5 / 2일차)** — **학습:** D 6~7강: skid buffer 이론·실습  
  **실습:** `skid_buffer.sv`·ready 랜덤 정지  
  **완료 기준:** backpressure에서 데이터 보존
- [ ] **Day 27 (주 5 / 3일차)** — **학습:** D AXI4 이론 섹션 또는 Arm AXI 채널 참고  
  **실습:** AW/W/B/AR/R 채널 및 handshake 타이밍 표  
  **완료 기준:** 쓰기/읽기 흐름 스케치
- [ ] **Day 28 (주 5 / 4일차)** — **학습:** D AXI4-Lite 설계 섹션 전반부  
  **실습:** `axi_lite_regs.sv` read path  
  **완료 기준:** AR/R 응답과 RREADY 지연 PASS
- [ ] **Day 29 (주 5 / 5일차)** — **학습:** D AXI4-Lite 설계 섹션 후반부  
  **실습:** write path 구현, AW/W 별도 버퍼링  
  **완료 기준:** AW/W 서로 다른 시점 도착 PASS
- [ ] **Day 30 (주 5 / 6일차)** — **학습:** AXI4-Lite 프로토콜 복습  
  **실습:** 랜덤 stall TB + register map 문서  
  **완료 기준:** 무손실 + BRESP/RRESP 확인

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week05/README.md`에 기록.

### Week 06 — AXI4-Stream / Zybo 통합

**사용 자료:** 인프런 D AXI4-Stream→AXI4→DMA/FPGA 섹션(선택) / Vivado

- [ ] **Day 31 (주 6 / 1일차)** — **학습:** D AXI4-Stream 섹션 이론  
  **실습:** TVALID/TREADY/TLAST 신호표  
  **완료 기준:** TLAST와 stall 조건 설명
- [ ] **Day 32 (주 6 / 2일차)** — **학습:** D AXI4-Stream 설계 실습  
  **실습:** `axis_fifo.sv` 또는 기존 CNN Stream RTL 검토  
  **완료 기준:** backpressure 처리 검증
- [ ] **Day 33 (주 6 / 3일차)** — **학습:** D AXI4 설계 이론·실습 개요  
  **실습:** burst LEN/SIZE/BURST와 AXI-Lite 차이 노트  
  **완료 기준:** 4-beat burst 주소 계산
- [ ] **Day 34 (주 6 / 4일차)** — **학습:** D DMA 설계 섹션 구조 파악  
  **실습:** DMA–DDR–Stream 블록도와 기존 CNN flow 비교  
  **완료 기준:** DMA 역할 및 데이터 방향 표시
- [ ] **Day 35 (주 6 / 5일차)** — **학습:** Vivado IP Integrator AXI IP 패키징 자료  
  **실습:** AXI4-Lite 제어 IP 패키징 및 Zynq PS 연결  
  **완료 기준:** Address Editor에서 매핑 완료
- [ ] **Day 36 (주 6 / 6일차)** — **학습:** Vitis/SDK bare-metal 참고, 기존 Zybo 환경  
  **실습:** PS C에서 CTRL 레지스터 쓰고 STATUS 읽기  
  **완료 기준:** 읽기/쓰기 UART 로그 저장

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week06/README.md`에 기록.

### Week 07 — ARM 명령어 / Architecture

**사용 자료:** KOCW B ARM 구조·프로그래머 모델·예외·명령어 강의

- [ ] **Day 37 (주 7 / 1일차)** — **학습:** B ‘CPU 성능, 저전력 설계’  
  **실습:** CPI/IPC/latency/throughput 비교  
  **완료 기준:** 정의와 예제 1개
- [ ] **Day 38 (주 7 / 2일차)** — **학습:** B ‘ARM 구조 및 프로그래머 모델’ 전반  
  **실습:** ARM 레지스터, PC/SP/LR, CPSR 역사적 모델 정리  
  **완료 기준:** A-profile와 M-profile 차이 메모
- [ ] **Day 39 (주 7 / 3일차)** — **학습:** B ‘ARM 구조 및 프로그래머 모델’ 후반  
  **실습:** Load/store와 주소 지정 방식  
  **완료 기준:** 메모리 접근 흐름 작성
- [ ] **Day 40 (주 7 / 4일차)** — **학습:** B ‘ARM 예외상황, ARM 어셈블리’  
  **실습:** 예외 발생·핸들러 복귀 흐름도  
  **완료 기준:** IRQ와 일반 함수 구별
- [ ] **Day 41 (주 7 / 5일차)** — **학습:** B ‘ARM 명령어’  
  **실습:** `add/sub/ldr/str/b/bl`와 조건 실행 정리  
  **완료 기준:** 짧은 함수 해석
- [ ] **Day 42 (주 7 / 6일차)** — **학습:** ARM 툴체인/디스어셈블 예제  
  **실습:** C 함수 `-O0/-O2` 비교, stack 분석  
  **완료 기준:** 어셈블리 차이 표

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week07/README.md`에 기록.

### Week 08 — Pipeline / Cache / MMU·MPU

**사용 자료:** KOCW B ARM7/ARM9, 캐시 메모리 1·2, MMU

- [ ] **Day 43 (주 8 / 1일차)** — **학습:** B ‘ARM7TDMI’  
  **실습:** 파이프라인 fetch/decode/execute 개념  
  **완료 기준:** 3단 파이프라인 그림
- [ ] **Day 44 (주 8 / 2일차)** — **학습:** B ‘ARM9TDMI’  
  **실습:** 파이프라인 확장/데이터 hazard  
  **완료 기준:** stall/forwarding 예제
- [ ] **Day 45 (주 8 / 3일차)** — **학습:** B ‘캐시 메모리 1’  
  **실습:** direct mapped cache 인덱스/태그  
  **완료 기준:** 주소 분해 3문제
- [ ] **Day 46 (주 8 / 4일차)** — **학습:** B ‘캐시 메모리 2’  
  **실습:** set associative, replacement, write 정책  
  **완료 기준:** Hit/miss 사례 계산
- [ ] **Day 47 (주 8 / 5일차)** — **학습:** B ‘Memory management unit’  
  **실습:** MMU/MPU 차이 및 보호 기능  
  **완료 기준:** A9 MMU vs M7 MPU 비교표
- [ ] **Day 48 (주 8 / 6일차)** — **학습:** B ‘ARM 개발 툴 및 디버그 지원’  
  **실습:** cache/pipeline/exception 핵심 정리  
  **완료 기준:** 5개 인터뷰 질문 답변

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week08/README.md`에 기록.

### Week 09 — ARM Software / Bare-metal

**사용 자료:** STM32 기존 환경 + ST 공식 자료 한글 번역 + CMSIS

- [ ] **Day 49 (주 9 / 1일차)** — **학습:** STM32CubeIDE/CubeMX 기본·프로젝트 생성 안내  
  **실습:** STM32 프로젝트 빌드·디버깅 환경 설정  
  **완료 기준:** 빌드 및 break 정상
- [ ] **Day 50 (주 9 / 2일차)** — **학습:** Startup, Reset_Handler, vector table 주제  
  **실습:** startup 파일과 reset 흐름 주석 정리  
  **완료 기준:** Reset→main 진입 설명
- [ ] **Day 51 (주 9 / 3일차)** — **학습:** Linker script, memory section 설명  
  **실습:** map 파일 `.text/.data/.bss` 추적  
  **완료 기준:** Flash/SRAM 위치 표
- [ ] **Day 52 (주 9 / 4일차)** — **학습:** Memory-mapped I/O, `volatile`, MCU RM GPIO 절  
  **실습:** HAL GPIO 토글 vs 레지스터 직접 쓰기  
  **완료 기준:** 2가지 방식 파형/LED 확인
- [ ] **Day 53 (주 9 / 5일차)** — **학습:** NVIC, Interrupt, EXTI 또는 TIM  
  **실습:** 타이머 ISR과 주기 GPIO 토글  
  **완료 기준:** 100회 인터럽트 카운트
- [ ] **Day 54 (주 9 / 6일차)** — **학습:** SW 디버깅 도구 복습  
  **실습:** watch/register/peripheral 뷰와 오류 사례  
  **완료 기준:** 디버깅 노트 1페이지

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week09/README.md`에 기록.

### Week 10 — Interrupt / DMA / ARM SW

**사용 자료:** STM32 공식 자료의 NVIC·UART·DMA 주제 한글 번역

- [ ] **Day 55 (주 10 / 1일차)** — **학습:** NVIC interrupt priority/subpriority  
  **실습:** 두 IRQ 우선순위 실험 계획  
  **완료 기준:** 우선순위 표 작성
- [ ] **Day 56 (주 10 / 2일차)** — **학습:** ISR와 공유 변수 `volatile` 및 원자성  
  **실습:** 카운터/플래그 공유 코드 검증  
  **완료 기준:** 경쟁 조건 메모
- [ ] **Day 57 (주 10 / 3일차)** — **학습:** UART polling  
  **실습:** `uart_polling.c`, 시간/CPU 대기 기록  
  **완료 기준:** 패킷 100개 송수신
- [ ] **Day 58 (주 10 / 4일차)** — **학습:** UART interrupt  
  **실습:** `uart_irq.c`, ring buffer 수신  
  **완료 기준:** 패킷 100개 송수신
- [ ] **Day 59 (주 10 / 5일차)** — **학습:** UART DMA  
  **실습:** `uart_dma.c`, 송·수신 실습  
  **완료 기준:** DMA 완료 이벤트 확인
- [ ] **Day 60 (주 10 / 6일차)** — **학습:** 3방식 비교·복습  
  **실습:** latency·CPU 관여도·오류율 결과 표  
  **완료 기준:** README 비교 분석 완성

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week10/README.md`에 기록.

### Week 11 — Cortex-M7 / STM32H7

**사용 자료:** ST STM32H7 Online Training (영문 문서 번역), Cortex-M7 자료

- [ ] **Day 61 (주 11 / 1일차)** — **학습:** STM32H7 시스템 아키텍처·버스 강의  
  **실습:** Cortex-M7/AXI/TCM/내부 SRAM 블록도  
  **완료 기준:** 각 경로 용도 구분
- [ ] **Day 62 (주 11 / 2일차)** — **학습:** ITCM/DTCM, SRAM memory map  
  **실습:** 코드·버퍼 배치 설계, linker sections 검토  
  **완료 기준:** 메모리별 접근 제약 설명
- [ ] **Day 63 (주 11 / 3일차)** — **학습:** I-Cache/D-Cache 관련 ST 교육  
  **실습:** 반복 연산 Cache ON/OFF 벤치마크  
  **완료 기준:** DWT cycle 값 기록
- [ ] **Day 64 (주 11 / 4일차)** — **학습:** DMA와 D-Cache coherency 문서  
  **실습:** cache clean/invalidate 실습 또는 사례 분석  
  **완료 기준:** 오류/해결 절차 기록
- [ ] **Day 65 (주 11 / 5일차)** — **학습:** MPU region attributes 주제  
  **실습:** Non-cacheable DMA buffer 구성  
  **완료 기준:** region 속성/정렬 정리
- [ ] **Day 66 (주 11 / 6일차)** — **학습:** M7 실습 종합  
  **실습:** cache/TCM/DMA 측정 보고서  
  **완료 기준:** 성능 비교 그래프·결론

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week11/README.md`에 기록.

### Week 12 — ARM + RTL 최종 SoC 프로젝트

**사용 자료:** 1~11주 자료 복습 / Zybo Cortex-A9 + FPGA PL

- [ ] **Day 67 (주 12 / 1일차)** — **학습:** 전체 회로/인터페이스 설계  
  **실습:** AXI4-Lite register map, FSM, testplan  
  **완료 기준:** 블록도+주소맵 작성
- [ ] **Day 68 (주 12 / 2일차)** — **학습:** Arithmetic Core RTL  
  **실습:** `mac_core.sv` 또는 ALU + start/done  
  **완료 기준:** 단독 TB PASS
- [ ] **Day 69 (주 12 / 3일차)** — **학습:** AXI4-Lite Wrapper 통합  
  **실습:** `axi_lite_accel.sv`와 상태 레지스터  
  **완료 기준:** read/write/interrupt 옵션 검증
- [ ] **Day 70 (주 12 / 4일차)** — **학습:** SystemVerilog 검증  
  **실습:** 랜덤 stall, reset, back-to-back test  
  **완료 기준:** 자동 PASS + 커버리지 목록
- [ ] **Day 71 (주 12 / 5일차)** — **학습:** Zybo PS/PL 통합  
  **실습:** Zynq PS bare-metal C로 start/status/result  
  **완료 기준:** UART 결과 로그/사진
- [ ] **Day 72 (주 12 / 6일차)** — **학습:** 리포트/포트폴리오 정리  
  **실습:** timing/utilization 보고서, 구조·이슈·해결 요약  
  **완료 기준:** 최종 README + GitHub push

**주간 회고:** 학습한 개념 3개 / 발생한 오류 1개 / 해결 방법 1개를 `week12/README.md`에 기록.

---

## 🗂️ 권장 GitHub 폴더 구조

```text
rtl-amba-arm-study/
├── README.md                   # 이 72일 체크리스트
├── week01/                    # ALU + TB
├── week02/                    # UART RX
├── week03/                    # Synchronous FIFO
├── week04/                    # APB GPIO
├── week05/                    # AXI4-Lite Register Bank
├── week06/                    # AXI Stream + Zybo PS/PL
├── week07/                    # ARM ISA + Assembly
├── week08/                    # Pipeline / Cache / MPU
├── week09/                    # Bare-metal STM32
├── week10/                    # UART Polling/IRQ/DMA
├── week11/                    # STM32H7 Cortex-M7 (별도 보드)
└── week12/                    # 최종 AXI Accelerator + ARM C
```

## 📝 주간 README 기록 템플릿

```markdown
# Week XX - 주제

## 목표
- 

## 공부 자료
- 강의 링크 및 수강 구간:
- 교재/참고 자료:

## 설계 구조
- 블록도:
- 주요 I/O와 레지스터맵:

## 검증 결과
- 테스트 항목:
- 예상 결과 / 실제 결과:
- 파형 및 로그:

## 에러와 해결
- 발생한 문제:
- 원인:
- 변경한 RTL/C 코드:
- 변경 전후 결과:

## 다음 주 보완할 것
- 
```

## 🏁 최종 완료 기준

- [ ] Verilog 조합·순차 RTL 작성 및 자동 검증 가능
- [ ] APB/AXI4-Lite에서 wait/stall을 포함한 read/write 검증 가능
- [ ] ARM 프로그래머 모델과 Cortex-A/Cortex-M 차이 설명 가능
- [ ] Bare-metal C에서 메모리 매핑 레지스터 접근 가능
- [ ] Cortex-M7의 TCM/Cache/MPU/DMA 관계 설명 가능
- [ ] Zybo PS(ARM)에서 PL(AXI4-Lite RTL IP)을 제어하는 데모 완성
- [ ] 최종 프로젝트의 RTL, Testbench, 파형, 합성·타이밍 보고서, README 공개

<img width="1037" height="192" alt="image" src="https://github.com/user-attachments/assets/dd673047-8a71-44f8-afce-d39ca824f5c0" />

### Parameter를 이용한 XNOR 모듈

- `parameter`를 사용하여 모듈의 비트 폭(`size`)과 시뮬레이션 지연(`delay`)을 설정
- G1: 기본 Parameter 적용 (`size=8`, `delay=15`)
- G2: Parameter Override 적용 (`size=4`, `delay=5`)
- TB를 통해 두 인스턴스의 XNOR 연산 결과 및 출력 지연 시간 비교
- `#delay`는 시뮬레이션 지연을 표현하며 실제 합성 회로의 물리적 지연을 의미하지 않음

**결론:** Parameter를 활용하면 동일한 RTL 모듈을 수정하지 않고도 인스턴스별로 비트 폭과 동작 설정을 변경하여 재사용할 수 있다.

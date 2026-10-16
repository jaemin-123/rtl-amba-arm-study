<img width="1036" height="144" alt="image" src="https://github.com/user-attachments/assets/9ce3cb0f-19b8-44c3-bfd7-0fbf7d17dcac" />

**Waveform 분석**
- **`{carry, sum}`** : Concatenation 연산자를 이용하여 덧셈 결과를 Carry(1bit)와 Sum(4bit)으로 분리
- **`a=1111`, `b=0001`** : 덧셈 결과가 `10000`(5bit)이므로 `carry=1`, `sum=0000` 출력
- 4bit 범위를 초과하는 덧셈 결과의 최상위 Carry-out을 별도의 신호로 확인함.

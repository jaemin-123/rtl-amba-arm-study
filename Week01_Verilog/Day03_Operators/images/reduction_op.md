<img width="1037" height="222" alt="image" src="https://github.com/user-attachments/assets/0b51ffbf-c1b9-4021-bf77-17628bf13a05" />

**Waveform 분석**
- **`logic_result` (`&&`)** : `b`, `c`가 모두 0이 아닐 때 1을 출력하며, 둘 중 하나라도 0이면 0을 출력
- **`bit_result` (`&`)** : `b`, `c`의 각 비트를 AND 연산하여 4bit 결과 출력
- **`y1`, `y2`** : 각각 일반 AND 연산 후 반전과 Reduction NAND(`~&`)를 사용했으며, 동일한 결과 출력
- **40ns** : `a=4'b1111`이 되면서 `y1`, `y2`가 동시에 0으로 변경되는 것을 확인

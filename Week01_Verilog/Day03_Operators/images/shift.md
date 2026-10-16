<img width="1034" height="192" alt="image" src="https://github.com/user-attachments/assets/da1b72de-d7d0-47bc-99c0-fd2a0a8baf2b" />

**Waveform 분석**
- **`out1` (`data1 << 2`)** : Left Shift로 왼쪽 2bit 이동, 오른쪽을 0으로 채워 `10110000` 출력
- **`out2` (`data1 >> 2`)** : Logical Right Shift로 오른쪽 2bit 이동, 왼쪽을 0으로 채워 `00101011` 출력
- **`out3` (`data1 >>> 2`)** : Signed Arithmetic Right Shift로 부호 비트(MSB=1)를 유지하며 오른쪽 2bit 이동하여 `11101011` 출력
- **`out4` (`data2 >>> 2`)** : Unsigned 데이터이므로 Arithmetic Shift 연산자를 사용해도 왼쪽을 0으로 채워 `00100011` 출력

**결론:** `>>`는 왼쪽을 0으로 채우지만, `>>>`는 피연산자의 Signed 여부에 따라 부호 확장 여부가 달라진다는 것을 확인함.

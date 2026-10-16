<img width="1032" height="225" alt="image" src="https://github.com/user-attachments/assets/a3ffba60-4616-4292-a1bf-2cef9eb2043f" />

### wire와 wand 비교

- **`wire`** : 하나의 신호에 여러 Driver가 연결되어 서로 다른 값(0, 1)을 출력하면 충돌로 인해 `X(Unknown)` 발생
- **`wand` (Wired-AND)** : 여러 Driver의 출력을 AND 연산하여 최종 출력 결정
- **`buf` (Buffer)** : 입력 신호를 반전 없이 그대로 출력하는 Gate Primitive

**결론:** `wire`는 Driver 간 충돌 시 X가 발생할 수 있지만, `wand`는 AND 연산을 통해 출력값이 결정된다.

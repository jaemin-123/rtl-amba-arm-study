cnt = 254
for _ in range(3):
    cnt = (cnt + 1) & 0xFF
    print(cnt)

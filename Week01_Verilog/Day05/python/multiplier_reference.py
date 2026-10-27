test_cases = [
    (0, 25),
    (1, 123),
    (3, 5),
    (15, 10),
    (128, 2),
    (255, 255)
]

def shift_add(a, b):
    result = 0
    shift_a = a
    shift_b = b

    for i in range(8):
        if shift_b & 1:
            result += shift_a

        shift_a <<= 1
        shift_b >>= 1

    return result

for a, b in test_cases:
    result = shift_add(a, b)
    expected = a * b

    if result == expected:
        print(f"PASS: {a} * {b} = {result}")
    else:
        print(f"FAIL: {a} * {b} = {result}, Expected = {expected}")

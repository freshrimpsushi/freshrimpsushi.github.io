from reprint import output
import time
print()
with output(initial_len=3, interval=0) as output_lines:
    for i in range(1,6):
        output_lines[0] = f"진행 경과[{i}/5]"
        for j in range(10):
            output_lines[1] = f"j = {j}"
            output_lines[2] = f"j^2 = {j**2}"
            time.sleep(0.1)
        time.sleep(0.5)
print()
print()
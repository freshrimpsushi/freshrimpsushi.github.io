import time
print("\n")
for i in range(1,6):
    print(f"진행 경과[{i}/5]")
    time.sleep(1)
print("\n")
print("\n")
for i in range(1,6):
    print(f"\r진행 경과[{i}/5]", end="")
    time.sleep(1)
print("\n")
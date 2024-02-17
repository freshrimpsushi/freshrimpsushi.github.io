import os

# os.system("start https://freshrimpsushi.com/dashboard/approve.php")
# while True: # (23.09.21 전)오류 났을 때 인터넷 페이지 무한 로딩 때문에 주석처리
for k in range(3): # (24.01.16 류) 10회 로딩으로 완화
    try:
        os.system("start http://localhost:1313/ko/posts/research")
        # os.system("hugo server -D -F --ignoreCache --disableFastRender") # (24.01.20 류) 캐시 무시
        os.system("hugo server -D -F") # (24.01.20 류) 캐시 무시
    except:
        print("🔴 preview.py stopped, automatic restoration is running...")
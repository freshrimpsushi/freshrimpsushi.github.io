import os

who = ""
while who != "류대식" or who != "전기현":
    who = input("이름 입력(류대식/전기현):")
    if who == "류대식":
        username = "dsryu0822"
        useremail = "rmsmsgood@naver.com"
        folder = "content/r_/0_recent"
        break
    elif who == "전기현":
        username = "physimatics"
        useremail = "bbbcaobb@gmail.com"
        folder = "content/j_/0_recent"
        break

txt = open("author.txt", 'w', encoding='utf-8')
txt.write(who)
txt.close()

try:
    os.makedirs(folder)
except FileExistsError:
    print("최근 문서 폴더가 이미 존재합니다")

os.system('git config user.name ' + username)
os.system('git config user.email ' + useremail)
os.system('git config credential.helper store')

try:
    os.makedirs("C:/public")
except FileExistsError: 
    print("퍼블릭이 이미 존재합니다")

os.chdir("C:/public")
print(os.getcwd())
os.system("git init")
os.system("git remote add web https://github.com/freshrimpsushi/freshrimpsushi.github.io.git")
os.system('git config user.name ' + username)
os.system('git config user.email ' + useremail)
os.system('git config credential.helper store')
os.system("git pull web master")

input("셋업 완료")

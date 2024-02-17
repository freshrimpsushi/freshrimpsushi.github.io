import os

commit = input("커밋 메세지를 입력해주세요: ")
os.system("git pull")
os.system("git add content/.")
os.system("git add layouts/partials/sidebar.html")
os.system("git status")
if commit == "":
    os.system('git commit -m "contents upload.py"')
else:
    os.system('git commit -m "' + commit + '"')
os.system("git push")

dir_admin = os.getcwd()
print(dir_admin)

os.chdir("C:/public")
os.system("git pull web master")
os.chdir(dir_admin)
os.system("hugo --cleanDestinationDir")
os.chdir("C:/public")
os.system("git add .")
os.system("git status")
if commit == "":
    os.system('git commit -m "commit by publish.py"')
else:
    os.system('git commit -m "' + commit + '"')
os.system('git push web master')
os.system("start https://github.com/freshrimpsushi/freshrimpsushi.github.io/commits/master")
input("발행완료")

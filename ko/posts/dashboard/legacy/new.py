import os
import csv
import re
from datetime import datetime, timedelta
import shutil

flag_julia = False
flag_python = False
flag_machinelearning = False
flag_geometry = False

try:
    os.chdir("C:/admin")
except:
    input("admin을 찾을 수 없습니다")

txt = open("author.txt", 'r', encoding='utf-8')
author = txt.read()
txt.close()

if author == "류대식":
    recent_folder = "content/r_/0_recent"
elif author == "전기현":
    recent_folder = "content/j_/0_recent"

try:
    last_post = os.listdir(recent_folder)[-1]
    idx = int(last_post[0:4])+1
    ID = str(idx)
    print("다음의 최신 포스트가 감지되었습니다:")
    print(last_post)

    last_post = os.path.join(recent_folder, last_post)
    index_md = open(last_post + "/index.md", 'r', encoding='utf-8')
    index = index_md.readlines()
    index_md.close()
except:
    print("마지막 글이 없습니다.\n수동으로 글을 작성해주세요.")
    raise FileNotFoundError

title = input("국문 제목: ")

if not title.find("줄리아") < 0:
    flag_julia = True
elif not title.find("파이썬") < 0:
    flag_python = True
elif not title.find("파이토치") < 0:
    flag_machinelearning = True
elif not title.find("텐서플로우") < 0:
    flag_machinelearning = True
elif not title.find("케라스") < 0:
    flag_machinelearning = True
elif not title.find("미분다양체") < 0:
    flag_geometry = True

## 압축
if author == "류대식":
    foldername = title.replace("\\","＼").replace("/","／").replace(" ","").replace("-","").replace("!","！").replace("?","？").replace(":","：").replace(",","").replace(".","")
    foldername = foldername.replace("에서","").replace("의","").replace("증명","").replace("유도","").replace("알고리즘","").replace("는법","").replace("시뮬레이션","")
    foldername = foldername.replace("모델","m").replace("정리","t").replace("함수","f").replace("소개","i").replace("분포","d").replace("평균과분산","2").replace("충분통계량과최대우도추정량","3").replace("방정식","eq").replace("정의","D")
    foldername = foldername.replace("줄리아","J").replace("존재성","E").replace("유일성","U").replace("해결법","S")
    foldername = foldername[-6:]
elif author == "전기현":
    foldername = input("폴더 이름: ")

slug = ""
while slug == "":
    print("              ↓띄어쓰기는 -로 자동 대체, 대문자는 소문자로 자동 대체")
    descreiption_input = input("영문 제목: ")
    slug = descreiption_input.lower()
    if slug == "":
        input("영문 제목이 입력되지 않았습니다")
print("              ↓미입력 시 영문 제목으로 대체")
descreiption = input("설명:")
if descreiption == "":
    descreiption = descreiption_input
    print("영문 제목으로 자동입력 되었습니다.")
slug = slug.replace(" ", "-")
input("")

publishdate = datetime.strptime(index[4][14:24], '%Y-%m-%d').date()
publishdate = publishdate + timedelta(days=2)
publishdate = publishdate.strftime('%Y-%m-%d')
print( str(idx) + "번 문서를 마지막 발행일로부터 이틀 뒤인 " + publishdate + "에 발행합니다.")

newfolder = recent_folder + "/" + ID.zfill(4) + '_' +\
            foldername.replace(":","：").replace("/","／").replace("?","？") + "/"
try:
    os.makedirs(newfolder)
except:
    input("국문 타이틀에 문제가 있는 것 같습니다.\n특수문자를 확인해주세요.")
md = open(newfolder + "index.md", 'w', encoding='utf-8')
md.write('---')
md.write('\ntitle: "' + title + '"')
md.write('\nmd.write('\nif author == "류대식":
    md.write('\npublishdate: "' + publishdate + '"')    
elif author == "전기현":
    md.write('\npublishdate: "' + publishdate + '" #early')
md.write('\nauthor: "' + author + '"')
if flag_julia:
    if title.find("플럭스") > -1:
        md.write('\ncategories: "머신러닝"')
    else :
        md.write('\ncategories: "줄리아"')
elif flag_python:
    md.write('\ncategories: "프로그래밍"')
elif flag_machinelearning:   
    md.write('\ncategories: "머신러닝"')
elif flag_geometry:   
    md.write('\ncategories: "기하학"')
else:
    md.write('\ncategories: ""')
md.write('\ntags: ')
md.write('\nweight: 600')
md.write('\nidx: ' + ID)
if flag_julia or flag_python or flag_machinelearning:
    md.write('\ncodeblock: true')
else:
    md.write('\ncodeblock: false')
md.write('\nplaceholder: ')
md.write("\nurl: '/posts/" + ID + "'")
if author == "전기현":
    md.write('\ndraft: true')    
md.write('\n---')
md.write('\n\n\n## \n')
md.close()

# auto-autolink
if author == "전기현":
    abb = input("방금 생성한 문서의 autolink 약어를 입력하세요: ")
else:
    abb = False

if abb:
    snp_r = open(".vscode/autolink_j.code-snippets", "rt", encoding="utf-8")
    line = snp_r.readlines()[:-1]
    snp_r.close()

    snp_w = open(".vscode/autolink_j.code-snippets", "wt", encoding="utf-8")
    line.append('\n')
    line.append('    "[' + abb + '](../' + str(idx) + ')": {"prefix": ["\\\\' + abb + '"], "body": ["[' + abb + '](../' + str(idx) + ')"]},\n')
    line.append('    "(../' + str(idx) + ')": {"prefix": ["\\\\' + abb + '"], "body": ["(../' + str(idx) + ')"]},\n')
    line.append('}')

    snp_w.writelines(line)
    snp_w.close()
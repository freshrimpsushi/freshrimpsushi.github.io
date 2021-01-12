import os
import time
import csv
import clipboard
import re
import requests
from datetime import datetime
from bs4 import BeautifulSoup

author = "류대식"

def rp(html_code, query, to=""):
    global score
    score -= html_code.count(query)
    return html_code.replace(query, to)


def delete(html_code, query):
    return html_code.replace(query, "")


def clear(html_code):
    while html_code.find("\n\n") > 0:
        html_code = html_code.replace("\n\n", "\n")
    return html_code

after_paste = """import os

index_md = open("index.md", 'r', encoding='utf-8')
index = index_md.readlines()
index_md.close()
index = ''.join(index)
for file in os.listdir():
    if file.find('.') > -1:
        continue
    os.system("ren " + file + " " + file + ".png")
    index = index.replace(file , file + ".png#center")

if os.getcwd().find("정리") > 0:
    index = index.replace("## 이관 대기", "## 정리")

index = index.replace("**증명**", "## 증명")
index = index.replace("■", "{{<qed>}}")

index = index.replace("> [\\n> ", "> [")
index = index.replace("> **\\n> ", "> **")

index = index.replace("\\n>\\n", "\\n")
index = index.replace("$$\\n", "\\n$$\\n")
index = index.replace("\\n$$", "\\n$$\\n")

index = index.replace("> $$", "> $$\\n> ")

index = index.replace("\\\\begin{eqnarray*}", "\\\\begin{eqnarray*}\\n")
index = index.replace("\\\\end{eqnarray*}", "\\n\\\\end{eqnarray*}")

index = index.replace("\\\\\\\\", "\\n\\\\\\\\\\\\ ")
index = index.replace("\\left\\{", "\\left\\\\{")
index = index.replace("\\right\\{", "\\right\\\\{")

index_line = index.split("\\n")
for t in range(len(index_line)-1):
    if index_line[t] == "$$":
        if index_line[t-1] == "":
            continue
        if index_line[t-1][0] == ">":
            index_line[t] = "> $$"
index = "\\n".join(index_line)

while index.find("  ") > 0:
    index = index.replace("  ", " ")

while index.find("\\n\\n\\n") > 0:
    index = index.replace("\\n\\n\\n", "\\n\\n")

index_md = open("index.md", 'w', encoding='utf-8')
index_md.write(index)
index_md.close()

os.system("rm ic_footnote.gif")
"""

# ----------------------------------- config -----------------------------------
URL = input("크롤링할 카테고리 페이지의 url을 입력해주세요:")
webpage = requests.get(URL)
if webpage.status_code == 404:
    print(URL + "은 존재하지 않습니다")
soup = str(BeautifulSoup(webpage.content, "html.parser"))
soup = soup[\
       soup.find('<strong class="category-description"></strong>'):\
       soup.find('!-- // s_list / 카테고리, 검색 리스트 -->')]
# print(soup)
re.findall("""<div*.>""", soup)

category = re.findall("""<b class="archives">.*</b>""", soup)[0]
category = category[(category.find('/')+1):(category.find('</b'))]
ID = re.findall("""<a class="link-article" href="/.*?category""", soup)
TITLE = re.findall("""<strong class="title">.*</strong>""", soup)
DATE = re.findall("""<span class="date">.*</span>""", soup)
N = len(ID)
if N == len(TITLE):
    print(str(N) + "개의 포스트가 발견되었습니다.")
    for t in range(N):
        ID[t] = re.sub("[^0-9]", "", ID[t]).zfill(4)
        TITLE[t] = re.sub("<[^<]*>", "", TITLE[t]).replace("?", "")
        publilshdate = re.sub("<[^<]*>", "", DATE[t]).replace(".", "-")
        title = re.findall("[^a-zA-Z]*[^a-zA-Z]", TITLE[t])[0].strip()
        print(ID[t] + " ─ " + title)
        try:
            slug = re.findall("[a-zA-Z ']*[a-zA-Z']", TITLE[t])[0].lower().strip()
        except IndexError:
            slug = " "*40 + "no english"
        print("     └ " + slug)
        newfolder = ID[t] + '_' + slug + "_" + title
        os.makedirs(newfolder)
        md = open(newfolder + "/index.md", 'w', encoding='utf-8')
        md.write('---')
        md.write('\ntitle: "' + title + '"  # 국문 타이틀')
        md.write('\nslug: "' + slug + '"  # 영문 url, 소문자만 사용')
        md.write('\npublishdate: "' + publilshdate + '"')
        md.write('\nauthor: "' + author + '"')
        md.write('\ncategories: ["' + category + '", ""]')
        md.write('\ntags: ["", ""]')
        md.write('\nweight: 600')
        md.write('\n---')
        md.write('\n\n\n## 이관 대기')
        md.close()
        py = open(newfolder + "/after_paste.py", 'w', encoding='utf-8')
        py.write(after_paste)
        py.close()
else:
    print("TistoryError 01: 포스트의 아이디와 아이템의 수가 일치하지 않습니다.")

input()

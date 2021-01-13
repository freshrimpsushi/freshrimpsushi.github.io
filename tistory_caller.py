import os
import csv
import re
import requests
from datetime import datetime
from bs4 import BeautifulSoup
import shutil

# test = True
test = False

if not test:
    URL = input("크롤링할 카테고리 페이지의 url을 입력해주세요:")
else:
    URL = "https://freshrimpsushi.tistory.com/category/%EC%BB%B4%ED%93%A8%ED%84%B0%20%EA%B3%B5%ED%95%99/%EB%A8%B8%EC%8B%A0%EB%9F%AC%EB%8B%9D"
webpage = requests.get(URL)
if webpage.status_code == 404:
    print(URL + "은 존재하지 않습니다")
soup = str(BeautifulSoup(webpage.content, "html.parser"))
soup = soup[\
       soup.find('<div class="area-common">'):\
       soup.find('!-- // s_list / 카테고리, 검색 리스트 -->')]
# print(soup)
re.findall("""<div*.>""", soup)
URL = URL[0:URL.find("?")]

category = re.findall("""<b class="archives">.*</b>""", soup)[0]
category = category[(category.find('/')+1):(category.find('</b'))]
if not os.path.isdir("categories/" + category):
    print("새로운 카테고리입니다: " + category)
    os.makedirs("categories/" + category)
    md = open("categories/" + category + "/_index.md", 'w', encoding='utf-8')
    md.write("---")
    md.write('\ntitle: "' + category + '"')
    md.write("\n---\n\n")
    md.write(category + "에 대해 소개한다.")
    md.close()

ID = re.findall("""<a class="link-article" href="/.*?category""", soup)
TITLE = re.findall("""<strong class="title">.*</strong>""", soup)
DATE = re.findall("""<span class="date">.*</span>""", soup)
AUTHOR = re.findall("""<span class="author">.*</span>""", soup)

N = len(ID)
if N == len(TITLE):
    print(str(N) + "개의 포스트가 발견되었습니다.")
    for t in range(N):
        ID[t] = re.sub("[^0-9]", "", ID[t]).zfill(4)
        publilshdate = re.sub("<[^<]*>", "", DATE[t]).replace(".", "-")
        
        TITLE[t] = re.sub("<[^<]*>", "", TITLE[t]).replace(":", "").replace("?", "")
        last_character = re.findall("[^a-zA-Z]*[^a-zA-Z]", TITLE[t])[0].strip()[-1]
        title = TITLE[t][0:TITLE[t].rfind(last_character)+1]        
        print(ID[t] + " ─ " + title)
        
        SLUG = re.findall("[a-zA-Z '\-]*[a-zA-Z'\-]", TITLE[t])
        slug = SLUG[-1].lower().strip()
        print("     └ " + slug)
        
        if AUTHOR[t].find("류") > 0:
            author_folder = "r_/"
            author = "류대식"
        elif AUTHOR[t].find("전") > 0:
            author_folder = "j_/"
            author = "전기현"
        
        newfolder = author_folder + category + "/" + ID[t] + '_' + title + "_" + slug
        if not test:
            try:
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
                md.write('\nidx: ' + ID[t])
                md.write('\n---')
                md.write('\n\n\n## 이관 대기')
                md.close()
                shutil.copyfile("after_paste.py", newfolder + "/after_paste.py")
            except FileExistsError:
                print(newfolder + " 생략")

else:
    print("TistoryError 01: 포스트의 아이디와 아이템의 수가 일치하지 않습니다.")

input()

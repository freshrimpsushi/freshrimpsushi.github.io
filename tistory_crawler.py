import os
import csv
import re
import requests
from datetime import datetime
from bs4 import BeautifulSoup
import shutil
import urllib.request
from urllib.error import HTTPError


def digit_phobia(string):
    for c in string:
        if c.isdigit():
            return True
    return False


# ----------------------------------------------------------

test = False

# post_range = [1935, 196, 1933, 1915, 1923, 1920, 1930, 197]
post_range = range(1900, 2000)
# post_range = range(1000, 1005)
for idx in post_range:
    if len(post_range) == 1:
        test = True
    # test = False
    
    if idx == 584 or idx == 1860 or idx == 1704:
        print("예외처리된 파일입니다")
        continue
    ID = str(idx)
    url = "https://freshrimpsushi.tistory.com/" + ID

    try:
        req = urllib.request.Request(url)
        res = urllib.request.urlopen(url).read()
    except HTTPError:
        continue

    SOUP = BeautifulSoup(res,'html.parser')
    allimgUrl = SOUP.select("img")
    imgUrl = []
    for item in allimgUrl:
        try:
            if item["alt"] != 'N':
                imgUrl.append(item)
        except KeyError:
            imgUrl.append(item)
    if imgUrl[-1]["src"].find("WhatIsYourMajor.png"):
        imgUrl.pop()
    # ----------------------------------------------------------

    soup = str(SOUP)
    meta_data = soup[soup.find('<div class="box-meta">'):soup.find('<!-- 에디터 영역 -->')]

    soup = soup[\
           soup.find('<!-- 에디터 영역 -->'):\
           soup.find('<div class="postbtn_like">')]

    re.findall("""<div*.>""", soup)
    url = url[0:url.find("?")]

    # ----------------------------------------------------------

    category = re.findall("""<a class="category" href=.*</a>""", meta_data)[0]
    category = re.sub("<[^<]*>", "", category)
    category = category[(category.find("/")+1):]
    
    if not os.path.isdir("categories/" + category) and not test:
        print("새로운 카테고리입니다: " + category)
        os.makedirs("categories/" + category)
        md = open("categories/" + category + "/_index.md", 'w', encoding='utf-8')
        md.write("---")
        md.write('\ntitle: "' + category + '"')
        md.write('\ncategories: "' + category + '"')
        md.write('\ncategory_stable: false')
        md.write('\nidx: 0')
        md.write("\n---\n\n")
        md.write('\n{{<remaster>}}\n')
        md.write(category + "에 대한 자동 페이지입니다.")
        md.close()
    else:
        if test: print("카테고리: " + category)

    DATE = re.findall("""<span class="date">.*</span>""", meta_data)[0]
    publishdate = re.sub("<[^<]*>", "", DATE)
    publishdate = publishdate[0:publishdate.rfind(".")].replace(" ", "").replace(".", "-")
    publishdate = publishdate.split('-')
    publishdate[1] = publishdate[1].zfill(2)
    publishdate[2] = publishdate[2].zfill(2)
    publishdate = '-'.join(publishdate)

    AUTHOR = re.findall("""<span class="writer">.*</span>""", meta_data)[0]
    if AUTHOR.find("류ㄷH식") > 0:
        author_folder = "r_/"
        author = "류대식"
    elif AUTHOR.find("전ㄱI현") > 0:
        author_folder = "j_/"
        author = "전기현"
    if test: print("발행일: " + publishdate + ", 작성자: " + author)

    TITLE = re.findall("""<h2 class="title-article">.*</h2>""", meta_data)[0]
    TITLE = re.sub("<[^<]*>", "", TITLE)
    TITLE = re.sub("""['":.,/\(\)\!\?\&]""", "", TITLE)\
            .replace("%&gt;", ">")
    last_character = re.findall("[^a-zA-Z]*[^a-zA-Z]", TITLE)[0].strip()[-1]
    title = TITLE[0:TITLE.rfind(last_character)+1]
    SLUG = TITLE[TITLE.rfind(last_character)+1:]
    slug = re.sub("""['":.,/()!?&]""", " ", SLUG)\
           .replace("ß", "ss").replace("[őö]", "oe").replace("é", "e")\
           .strip().lower().replace(" ", "-").replace("–", "-").replace("--", "-")
    if len(re.findall("[\u3131-\u3163\uac00-\ud7a3]", slug)) > 0 or slug=='':
        title = TITLE
        slug = str(ID)
    print(ID.zfill(4) + " ─ " + title)
    if test: print("     └ " + slug)

    # ----------------------------------------------------------
    
    soup = soup.replace("</p><p><b>증명", "</p>\n## 증명")
    soup = soup.replace("</p><p><b>유도", "</p>\n## 유도")
    soup = soup.replace("</b></p><p>", "\n<p>")
    for keyword in ["Strategy", "Case", "Part", "[", "(",
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]:
        soup = soup.replace("</p><p><b>" + keyword, "</p>\n\n"  + keyword)
        soup = soup.replace('</p><p style="margin-left: 2em;"><b>' + keyword, "</p>\n\n<b>"  + keyword)
    # ----------------------------------------------------------
    
    footnote = BeautifulSoup(soup, 'html.parser').select("sup")
    for sup in range(len(footnote)):
        if test: print("[^" + str(sup + 1) + "]")
        footnote_id = footnote[sup].find("a")["href"][1:]
        soup = soup.replace(str(footnote[sup]), "[^" + str(sup + 1) + "]")
        soup = soup.replace('<li id="' + footnote_id + '">', "[^" + str(sup + 1) + "]: ")
    soup = re.sub('<a href="#footnote_.*</a></li>', "", soup)

    LINKS = BeautifulSoup(soup, 'html.parser').select("a")
    for link in LINKS:
        temp = str(link)
        temp = re.sub("<a[^<]*>", "[", temp)
        temp = re.sub("</a>", "](", temp)
        if test: print(temp + link["href"] + ")")
        temp = temp + link["href"] + ")"
        soup = soup.replace(str(link), temp)
    soup = soup.replace("https://freshrimpsushi.tistory.com/", "{{<Tistory>}}/")
    soup = soup.replace("http://freshrimpsushi.tistory.com/", "{{<Tistory>}}/")
    soup = soup.replace("freshrimpsushi.tistory.com/", "{{<Tistory>}}/")

    for img in imgUrl:
        if str(img).find("BlogIcon") > 0:
            continue
        try:
            temp = re.sub("[ \u3131-\u3163\uac00-\ud7a3]*", "", img["filename"])
        except KeyError:
            temp = img["src"][-10:-1]
        if temp.find(".") == 0:
            temp = img["src"][-10:-1] + temp
        soup = soup.replace(str(img), "![" + temp + "](" + temp + "#center)\n")
        
    soup = re.sub("<!--[^<]*-->", "", soup)
    soup = re.sub("<script[^<]*</script>", "", soup)
    soup = re.sub("<ins[^<]*</ins>", "", soup)

    soup = soup.replace("""<p style="margin-left: 2em;"><span style="font-family: Dotum, 돋움;">""", "\n")
    soup = re.sub("""</td>""", "</td>\n", soup) #순서 지켜야함
    soup = re.sub("""<table .*colorscripter.*</td>""", "\n```\n", soup) #순서 지켜야함
    soup = re.sub('<div[^<]*line-height:130%">', "\n", soup) #순서 지켜야함

    soup = re.sub("<h3[^<]*>", "## ", soup)
    soup = re.sub("<pre><code>", "```\n", soup)
    soup = re.sub("</code></pre>", "```", soup)
    
    soup = re.sub("<code>", "`", soup); soup = re.sub("</code>", "`", soup)
    soup = re.sub("「", "\n```\n", soup); soup = re.sub("」", "\n```\n", soup)
    soup = re.sub("<b>", "**", soup); soup = re.sub("</b>", "** ", soup)

    soup = re.sub("<blockquote[^<]*>", "\n\n", soup)
    soup = re.sub("</blockquote>", "\n\n", soup)

    for html in ["pre","p", "br", "div", "ol", "ul",
                 "h1", "h2", "h3", "li", "span",
                 "table", "tr", "tbody", "td", "font",
                 "hr class", "b style"]:
        soup = re.sub("<" + html + "[^<]*>", "", soup)
        soup = re.sub("</" + html + ">", "", soup)
    soup = soup.replace("\n반응형\n", "")
    soup = re.sub("! .*1호기.*습니다.", "", soup)
    soup = re.sub("\?category=[0-9]{6}", "", soup)
    soup = soup.replace("[cs](http://colorscripter.com/info#e)", "```")
    soup = soup.replace("```\n\n\n", "```")

    soup = soup.replace("■", "{{<qed>}}\n")
    for be in ["bmatrix", "pmatrix", "matrix",
               "eqnarray", "eqnarray*", "align", "align*"]:
        soup = soup.replace("\\begin{" + be + "}",\
                            "\\begin{" + be + "}\n")
        soup = soup.replace("\\end{" + be + "}",\
                            "\n\\end{" + be + "}")

    soup = soup.replace("\\\\", "\n\\\\\\ ")
    soup = soup.replace("\\left\\{", "\\left\\\\{")
    soup = soup.replace("\\right\\}", "\\right\\\\}")
    soup = soup.replace("$$", "\n$$\n")
    soup = re.sub("&gt;", ">", soup)
    soup = re.sub("&lt;", "<", soup)
    soup = re.sub("&amp;", "&", soup)

    #----- not mine
    # soup = soup.replace("$(\mathrm{", "**<sup>")
    # soup = soup.replace("})$**", "</sup>")
    #----- not mine

    sup = ""
    soup_bold = soup.split("**")
    for i in range(len(soup_bold)):
        if soup_bold[i] == '':
            continue
        soup_bold[i] = sup + soup_bold[i]
        if not digit_phobia(soup_bold[i]) and\
            not soup_bold[i][0].encode().isalpha() and\
            soup_bold[i][-1].encode().isalpha():
            if test: print("   sup:" + soup_bold[i] + " /")
            for j in range(len(soup_bold[i])):
                if soup_bold[i][j].encode().isalpha():
                    break
            sup = "<sup>" + soup_bold[i][j:] + "</sup>"
            soup_bold[i] = soup_bold[i][0:j]
        else:
            sup = ""
    soup = "**".join(soup_bold)

    soup = soup.strip()

    # ----------------------------------------------------------

    # issue #4
    soup = soup.replace("^*", "^{ * }")
    soup = soup.replace("^{*}", "^{ * }")


    # soup = soup.replace("{x}", "x")
    soup = soup.replace("_", "\_")

    # ----------------------------------------------------------

    if soup.find("```") > -1 :
        codeblock = "true"
    else:
        codeblock = "false"
    
    # ----------------------------------------------------------

    newfolder = author_folder + category + "/" + ID.zfill(4) + '_' + title + "_" + slug + "/"
    if not test:
        try:
            os.makedirs(newfolder)
            md = open(newfolder + "index.md", 'w', encoding='utf-8')
            md.write('---')
            md.write('\ntitle: "' + title + '"  # 국문 타이틀')
            md.write('\nslug: "' + slug + '"  # 영문 url, 소문자만 사용')
            md.write('\ndescription: "' + slug.replace("-"," ") + '"')
            md.write('\npublishdate: "' + publishdate + '"')
            md.write('\nauthor: "' + author + '"')
            md.write('\ncategories: "' + category + '"')
            md.write('\ntags: ')
            md.write('\nweight: 600')
            md.write('\nidx: ' + ID)
            md.write('\ncodeblock: ' + codeblock)
            md.write('\nplaceholder: ')
            md.write('\naliases: ')
            md.write('\n    - ' + ID)
            md.write('\n---')
            md.write('\n\n\n## \n')
            md.write('\n{{<remaster>}}\n')
            md.write(soup)
            md.close()
            # shutil.copyfile("after_paste.py", newfolder + "/after_paste.py")

            if test: print(str(len(imgUrl)) + "개의 이미지 발견!")
            for img in imgUrl:
                if str(img).find("BlogIcon") > 0:
                    continue
                try:
                    temp = re.sub("[ \u3131-\u3163\uac00-\ud7a3]*", "", img["filename"])
                except KeyError:
                    temp = img["src"][-10:-1]
                if temp.find(".") == 0:
                    temp = img["src"][-10:-1] + temp
                try:
                    print(img["src"] + " - " + temp)
                    urllib.request.urlretrieve(img["src"], newfolder + temp)
                except HTTPError:
                    print("    ! 404Error: ")
                except UnicodeEncodeError:
                    print("    ! UnicodeError: ")
                except KeyError:
                    print("파일 이름 없음")
        except FileExistsError:
            print(newfolder + " 생략")
    else:
        print(ID + "번 문서에 대한 테스트가 종료되었습니다")
        input(soup)
        # os.system("start http://localhost:1313/" + slug)
        # os.system("hugo server -D")

    # input("press to next post")
os.system("pause")

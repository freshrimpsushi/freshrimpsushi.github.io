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

# test = True
test = False

# for idx in [496]:
for idx in range(1, 2000):
# for idx in [1235, 1270, 1871, 1873, 1880]:
    if idx == 584 or idx == 1860:
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
    imgUrl = SOUP.select("img")[0:-11]

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
        md.write("\n---\n\n")
        md.write(category + "에 대해 소개한다.")
        md.close()
    else:
        print("카테고리: " + category)

    DATE = re.findall("""<span class="date">.*</span>""", meta_data)[0]
    publilshdate = re.sub("<[^<]*>", "", DATE)
    publilshdate = publilshdate[0:publilshdate.rfind(".")].replace(" ", "").replace(".", "-")

    AUTHOR = re.findall("""<span class="writer">.*</span>""", meta_data)[0]
    if AUTHOR.find("류ㄷH식") > 0:
        author_folder = "r_/"
        author = "류대식"
    elif AUTHOR.find("전ㄱI현") > 0:
        author_folder = "j_/"
        author = "전기현"
    print("발행일: " + publilshdate + ", 작성자: " + author)

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
    print("     └ " + slug)

    # ----------------------------------------------------------
    

    footnote = BeautifulSoup(soup, 'html.parser').select("sup")
    for sup in range(len(footnote)):
        print("[^" + str(sup + 1) + "]")
        footnote_id = footnote[sup].find("a")["href"][1:]
        soup = soup.replace(str(footnote[sup]), "[^" + str(sup + 1) + "]")
        soup = soup.replace('<li id="' + footnote_id + '">', "[^" + str(sup + 1) + "]: ")
    soup = re.sub('<a href="#footnote_.*</a></li>', "", soup)

    LINKS = BeautifulSoup(soup, 'html.parser').select("a")
    for link in LINKS:
        temp = str(link)
        temp = re.sub("<a[^<]*>", "[", temp)
        temp = re.sub("</a>", "](", temp)
        print(temp + link["href"] + ")")
        temp = temp + link["href"] + ")"
        soup = soup.replace(str(link), temp)
    soup = soup.replace("https://freshrimpsushi.tistory.com/", """{{<baseURL>}}""")

    for img in imgUrl:
        if str(img).find("BlogIcon") > 0:
            continue
        try:
            temp = re.sub("[ \u3131-\u3163\uac00-\ud7a3]*", "", img["filename"])
        except KeyError:
            temp = img["src"][-10:-1]
        if temp.find(".") == 0:
            temp = img["src"][-10:-1] + temp
        soup = soup.replace(str(img), "![img](" + temp + "#center)")
        
    soup = re.sub("<!--[^<]*-->", "", soup)
    soup = re.sub("<script[^<]*</script>", "", soup)
    soup = re.sub("<ins[^<]*</ins>", "", soup)
    
    soup = re.sub("""</td>""", "</td>\n", soup) #순서 지켜야함
    soup = re.sub("""<table .*colorscripter.*</td>""", "\n```", soup) #순서 지켜야함
    soup = re.sub('<div[^<]*line-height:130%">', "\n", soup) #순서 지켜야함

    soup = re.sub("<h3[^<]*>", "## ", soup)
    soup = re.sub("<pre><code>", "```\n", soup); soup = re.sub("</code></pre>", "\n```", soup)
    soup = re.sub("<code>", "`", soup); soup = re.sub("</code>", "`", soup)
    soup = re.sub("「", "\n```\n", soup); soup = re.sub("」", "\n```\n", soup)
    soup = re.sub("<b>", "**", soup); soup = re.sub("</b>", "** ", soup)

    for html in ["pre","p", "br", "div", "ol", "ul",
                 "h1", "h2", "h3", "li", "blockquote", "span",
                 "table", "tr", "tbody", "td", "font",
                 "hr class", "b style"]:
        soup = re.sub("<" + html + "[^<]*>", "", soup)
        soup = re.sub("</" + html + ">", "", soup)
    soup = soup.replace("\n반응형\n", "")
    soup = re.sub("! .*1호기.*습니다.", "", soup)
    soup = re.sub("\?category=[0-9]{6}", "", soup)
    soup = soup.replace("[cs](http://colorscripter.com/info#e)", "```")
    soup = soup.replace("```\n\n\n", "```\n")

    soup = soup.replace("■", "{{<qed>}}")
    soup = soup.replace("\\begin{eqnarray*}", "\\begin{eqnarray*}\n")
    soup = soup.replace("\\end{eqnarray*}", "\n\\end{eqnarray*}")
    soup = soup.replace("\\begin{bmatrix}", "\\begin{bmatrix}\n")
    soup = soup.replace("\\end{bmatrix}", "\n\\end{bmatrix}")
    soup = soup.replace("\\begin{pmatrix}", "\\begin{pmatrix}\n")
    soup = soup.replace("\\end{pmatrix}", "\n\\end{pmatrix}")
    soup = soup.replace("\\begin{matrix}", "\\begin{matrix}\n")
    soup = soup.replace("\\end{matrix}", "\n\\end{matrix}")

    soup = soup.replace("\\\\", "\n\\\\\\ ")
    soup = soup.replace("\\left\\{", "\\left\\\\{")
    soup = soup.replace("\\right\\}", "\\right\\\\}")
    soup = soup.replace("$$", "\n$$\n")
    soup = re.sub("&gt;", ">", soup)
    soup = re.sub("&lt;", "<", soup)
    soup = re.sub("&amp;", "&", soup)

    #----- not mine
    soup = soup.replace("$(\mathrm{", "**<sup>")
    soup = soup.replace("})$**", "</sup>")
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
            print("   sup:" + soup_bold[i] + " /")
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

    newfolder = author_folder + category + "/" + ID.zfill(4) + '_' + title + "_" + slug + "/"
    if not test:
        try:
            os.makedirs(newfolder)
            md = open(newfolder + "index.md", 'w', encoding='utf-8')
            md.write('---')
            md.write('\ntitle: "' + title + '"  # 국문 타이틀')
            md.write('\nslug: "' + slug + '"  # 영문 url, 소문자만 사용')
            md.write('\npublishdate: "' + publilshdate + '"')
            md.write('\nauthor: "' + author + '"')
            md.write('\ncategories: ["' + category + '", ""]')
            md.write('\ntags: ["", ""]')
            md.write('\nweight: 600')
            md.write('\nidx: ' + ID)
            md.write('\naliases: ')
            md.write('\n    - ' + ID)
            md.write('\n---')
            md.write('\n\n\n## \n')
            md.write(soup)
            md.close()
            # shutil.copyfile("after_paste.py", newfolder + "/after_paste.py")

            print(str(len(imgUrl)) + "개의 이미지 발견!")
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

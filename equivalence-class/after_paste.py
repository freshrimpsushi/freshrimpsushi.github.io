import os

def digit_phobia(string):
    for c in string:
        if c.isdigit():
            return True
    return False

test = False

index_md = open("index.md", 'r', encoding='utf-8')
index = index_md.readlines()
index_md.close()
index = ''.join(index)
changed = False

# --------------------------------------------------------- 기본기능

if index.find("■") > 0:
    changed = True
    index = index.replace("■", "{{<qed>}}")

if index.find("**증명**") > 0:
    changed = True
    index = index.replace("**증명**", "## 증명")
if index.find("**유도**") > 0:
    changed = True
    index = index.replace("**유도**", "## 유도")

if index.find("> [\n>") > 0:
    changed = True
    index = index.replace("> [\n> ", "> [")
if index.find("> **\n> ") > 0:
    changed = True
    index = index.replace("> **\n> ", "> **")

if index.find("\n> ") > 0:
    changed = True
    index = index.replace("\n> ", "\n")
if index.find("\n>\n") > 0:
    changed = True
    index = index.replace(">\n", "\n")

# --------------------------------------------------------- 고급기능

# 1) 정리 자동 파악
# if index.find("## 이관대기") < 0 and os.getcwd().find("정리") > 0:
#     changed = True
#     index = index.replace("## 이관 대기", "## 정리")

# 2) 이미지 링킹, 가운데 정렬
if index.find(".png#center") < 0:
    changed = True
    for file in os.listdir():
        if file.find('.') > -1:
            continue
        os.system("ren " + file + " " + file + ".png")
        index = index.replace(file , file + ".png#center")

# 3) 위첨자 변환
if index.find("<sup>") < 0:
    changed = True
    sup = ""
    index_bold = index.split("**")
    for i in range(len(index_bold)):
        if index_bold[i] == '':
            continue
        index_bold[i] = sup + index_bold[i]
        if not digit_phobia(index_bold[i]) and\
            not index_bold[i][0].encode().isalpha() and\
            index_bold[i][-1].encode().isalpha():
            print("   sup:" + index_bold[i] + " /")
            for j in range(len(index_bold[i])):
                if index_bold[i][j].encode().isalpha():
                    break
            sup = "<sup>" + index_bold[i][j:] + "</sup>"
            index_bold[i] = index_bold[i][0:j]
        else:
            sup = ""
    index = "**".join(index_bold)

# 4) 수식 자동화
if index.find("\n$$\n") < 0:
    changed = True
    index = index.replace("\\begin{eqnarray*}", "\\begin{eqnarray*}\n")
    index = index.replace("\\end{eqnarray*}", "\n\\end{eqnarray*}")
    index = index.replace("\\begin{bmatrix}", "\\begin{bmatrix}\n")
    index = index.replace("\\end{bmatrix}", "\n\\end{bmatrix}")
    index = index.replace("\\begin{pmatrix}", "\\begin{pmatrix}\n")
    index = index.replace("\\end{pmatrix}", "\n\\end{pmatrix}")
    index = index.replace("\\begin{matrix}", "\\begin{matrix}\n")
    index = index.replace("\\end{matrix}", "\n\\end{matrix}")

    index = index.replace("\\\\", "\n\\\\\\ ")
    index = index.replace("\\left\\{", "\\left\\\\{")
    index = index.replace("\\right\\}", "\\right\\\\}")

    # index = index.replace("\n> $$", "\n> $$\n> ")
    index = index.replace("$$\n", "\n$$\n")
    index = index.replace("\n$$", "\n$$\n")
    # index_line = index.split("\n")
    # for t in range(len(index_line)-1):
    #     if index_line[t] == "$$":
    #         if index_line[t-1] == "":
    #            continue
    #         if index_line[t-1][0] == ">":
    #             index_line[t] = "> $$"
    # index = "\n".join(index_line)

# 행 줄이기 기능은 아예 쓰면 안될듯
#if index.find("```") < 0:
#    while index.find("\n\n\n") > 0:
#        index = index.replace("\n\n\n", "\n\n")

if not test:
    if changed:
        index_md = open("index.md", 'w', encoding='utf-8')
        index_md.write(index)
        index_md.close()
        os.remove("ic_footnote.gif")
        input()
else:
    print(index)

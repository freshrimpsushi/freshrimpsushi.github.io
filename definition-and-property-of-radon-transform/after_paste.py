import os

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

index = index.replace("> [\n> ", "> [")

index = index.replace("\n>\n", "\n")
index = index.replace("$$\n", "\n$$\n")
index = index.replace("\n$$", "\n$$\n")

index = index.replace("> $$", "> $$\n> ")

index = index.replace("\\begin{eqnarray*}", "\\begin{eqnarray*}\n")
index = index.replace("\\end{eqnarray*}", "\n\\end{eqnarray*}")

index = index.replace("\\\\", "\n\\\\\\ ")
index = index.replace("\left\{", "\left\\{")
index = index.replace("\right\{", "\right\\{")

index_line = index.split("\n")
for t in range(len(index_line)-1):
    if index_line[t] == "$$":
        if index_line[t-1] == "":
            continue
        if index_line[t-1][0] == ">":
            index_line[t] = "> $$"
index = "\n".join(index_line)

while index.find("  ") > 0:
    index = index.replace("  ", " ")

while index.find("\n\n\n") > 0:
    index = index.replace("\n\n\n", "\n\n")

index_md = open("index.md", 'w', encoding='utf-8')
index_md.write(index)
index_md.close()

os.system("rm ic_footnote.gif")

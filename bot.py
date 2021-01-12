import os
import csv
import re
from datetime import datetime
import shutil

test = True
caution = input("정말로 사용하려면 y를 입력해주세요")
if caution != "y":
    raise
    
for author in ["j_", "r_"]:
    # 소유자 예외규칙
    depth1 = os.path.join(author)
    print(depth1)
    for category in os.listdir(depth1):
        # 카테고리 예외규칙
        depth2 = os.path.join(depth1, category)
        print(depth2)
        for post in os.listdir(depth2):
            depth3 = os.path.join(depth2, post)
            print(depth3)
            index_md = open(depth3 + "/index.md", 'r', encoding='utf-8')
            index = index_md.readlines()
            index_md.close()
            index = ''.join(index)

            # -------------------------------------------------------------
            if index.find("<sup>") < 0:
                sup = ""
                index_bold = index.split("**")
                for i in range(len(index_bold)):
                    index_bold[i] = sup + index_bold[i]
                    if not index_bold[i][0].encode().isdigit() and\
                       not index_bold[i][1].encode().isdigit() and\
                       not index_bold[i][2].encode().isdigit() and\
                       ((not index_bold[i][0].encode().isalpha()) and\
                        (index_bold[i][-1].encode().isalpha())) and\:
                        print(index_bold[i])
                        for j in range(len(index_bold[i])):
                            if index_bold[i][j].encode().isalpha():
                                break
                        sup = "<sup>" + index_bold[i][j:] + "</sup>"
                        index_bold[i] = index_bold[i][0:j]
                    else:
                        sup = ""
                index = "**".join(index_bold)
            index_md = open(depth3 + "/index.md", 'w', encoding='utf-8')
            index_md.write(index)
            index_md.close()
            # 폴더이름 맞춰줌
            # title = index[1]
            # title = title[title.find('"')+1:]
            # title = title[0:title.find('"')]
            # slug = index[2]
            # slug = slug[slug.find('"')+1:]
            # slug = slug[0:slug.find('"')]
            # os.rename(depth3, os.path.join(depth2, post[0:4] + "_" + title + "_" + slug).replace("?",""))
            input()
        input()

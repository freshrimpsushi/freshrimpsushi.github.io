import os
import csv
import re
from datetime import datetime
import shutil

caution = input("정말로 사용하려면 y를 입력해주세요")
if caution != "y":
    raise
    
for author in ["j_", "r_"]:
    depth1 = os.path.join(author)
    print(depth1)
    for category in os.listdir(depth1):
        depth2 = os.path.join(depth1, category)
        print(depth2)
        for post in os.listdir(depth2):
            depth3 = os.path.join(depth2, post)
            print(depth3)
            index_md = open(depth3 + "/index.md", 'r', encoding='utf-8')
            index = index_md.readlines()
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

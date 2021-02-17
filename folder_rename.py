import os
import csv
import re
from datetime import datetime
import shutil

caution = input("정말로 사용하려면 y를 입력해주세요")
if caution != "y":
    raise
    
# for author in ["j_", "r_"]:
for author in ["r_"]:
    depth1 = os.path.join(author)
    print(depth1)
    # for category in os.listdir(depth1):
    for category in ["알고리즘"]:
        if category == "main":
            print("mian")
            continue
        depth2 = os.path.join(depth1, category)
        print(depth2)
        for post in os.listdir(depth2):
            depth3 = os.path.join(depth2, post)
            print(depth3)
            index_md = open(depth3 + "/index.md", 'r', encoding='utf-8')
            index = index_md.readlines()
            index_md.close()
            # 폴더이름 맞춰줌
            title = index[1]
            title = title[title.find('"')+1:]
            title = title[0:title.find('"')]
            title = title.replace("\\","＼").replace("/","／").replace(" ","").replace("-","").replace("!","！").replace("?","？").replace(":","：").replace("n","ｎ")
            title = title.replace("에서","").replace("의","").replace("증명","").replace("유도","").replace("알고리즘","").replace("하는법","").replace("시뮬레이션","")
            title = title.replace("모델","m").replace("정리","t").replace("함수","f").replace("평균과분산","2")
            title = title[-6:]
            # slug = index[2]
            # slug = slug[slug.find('"')+1:]
            # slug = slug[0:slug.find('"')]
            
            # os.rename(depth3, os.path.join(depth2, post[0:4]).replace("?",""))
            # os.rename(depth3, os.path.join(depth2, post[0:4] + "_" + title + "_" + slug).replace("?",""))
            os.rename(depth3, os.path.join(depth2, index[9][5:-1].zfill(4) + "_" + title))
            # input()
        # input()

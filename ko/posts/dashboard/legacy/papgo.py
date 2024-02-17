import os
import sys
import urllib.request
client_id = "V4GiuDh11S0XJMAKn4pP"
client_secret = "itkIFsyhJc"

temp = open("./content/r_/0_recent/2239_우도f정/index.md", "r+", encoding = 'utf-8-sig').read().split("\n")
temp[1] = 'title: "' + temp[3].split('"')[1] + '"'
korean_post = '\n'.join(temp).replace("류대식", "Daesick Ryu")
korean_post

korean_post.split("$$")[3]

cut1 = (korean_post.find("---",2))
header = korean_post[0:cut1]
korean_post = korean_post[(cut1+3):]

encText = urllib.parse.quote(korean_post)
data = "source=ko&target=en&text=" + encText
url = "https://openapi.naver.com/v1/papago/n2mt"
request = urllib.request.Request(url)
request.add_header("X-Naver-Client-Id",client_id)
request.add_header("X-Naver-Client-Secret",client_secret)
response = urllib.request.urlopen(request, data=data.encode("utf-8"))
rescode = response.getcode()
if(rescode==200):
    response_body = response.read()
    print(response_body.decode('utf-8'))
else:
    print("Error Code:" + rescode)

# translated_post = response_body.decode('utf-8')
translated_post = response_body.decode('cp949')
translated_post = translated_post[
    (translated_post.find('translatedText":"') + 17):translated_post.find('","engineType"')]

result = header + "---\n\n" + translated_post
result = result.replace("\\n","\n")

exported_file = open("./content/r_/0_recent/2239_우도f정/index.en.md", "w", encoding='utf-8')
exported_file.write(result)
exported_file.close()
import os
import re

idx = input("문서 번호를 입력하세요: ")
if len(idx) == 1:
    idx = '000' + idx
elif len(idx) == 2:
    idx = '00' + idx
elif len(idx) == 3:
    idx = '0' + idx
if idx == '':
    print('Error: 문서 번호를 입력하세요.')
    exit()

language = input("도착 언어를 입력하세요 (en, jp): ")
if language == '':
    print('Error: 도착 언어를 입력하세요.')
    exit()

if language == '두':
    language = 'en'
elif language == 'ㅓㅔ':
    language = 'jp'

cd = os.path.dirname(os.path.realpath(__file__))

# 현재 경로에서 전체 하위 폴더를 뒤져서 idx로 시작하는 폴더 찾는 코드
for root, dirs, files in os.walk(cd):
    for dir in dirs:
        if dir.startswith(idx):
            cd = os.path.join(root, dir)
            break
print(cd)

# 도착언어 마크다운 파일이 있는지 확인하고 없으면 복사해서 만들기
if not os.path.isfile(cd + f"/index.{language}.md"):
    f = open(cd + "/index.md", 'r', encoding='utf-8')
    lines = f.readlines()
    f.close()

    f = open(cd + f"/index.{language}.md", 'w', encoding='utf-8')
    f.writelines(lines)
    f.close()

# 도착언어 마크다운 파일 열기1
f = open(cd + f"/index.{language}.md", 'r', encoding='utf-8')
lines = f.readlines()
front_matter = ''.join(lines[:15])
doc = ''.join(lines[15:])
f.close()
print(front_matter)

# displaystyle equation 찾아서 치환###############################
# 정규 표현식 패턴 (달러달러 사이의 모든 것을 포함)
display_pattern = r"\$\$.*?\$\$"

display_matches = re.findall(display_pattern, doc, re.DOTALL)

display_dic = {}
for i, match in enumerate(display_matches):
    display_dic[f'▶eq{i+1}◀'] = f'{match}'

# 치환 함수
def display_replace_func(match):
    display_replace_func.counter += 1  # 카운터 증가
    return f"▶eq{display_replace_func.counter}◀"

# 카운터 초기화
display_replace_func.counter = 0

# 치환
doc = re.sub(display_pattern, display_replace_func, doc, flags=re.DOTALL)
#################################################################

# inline equation 찾아서 치환#####################################
# 정규 표현식 패턴 (달러 사이의 모든 것을 포함)
inline_pattern = r"\$.*?\$"

inline_matches = re.findall(inline_pattern, doc)

inline_dic = {}
for i, match in enumerate(inline_matches):
    inline_dic[f'▷eq{i+1}◁'] = f'{match}'
# print(inline_dic)
    
# 치환 함수
def inline_replace_func(match):
    inline_replace_func.counter += 1  # 카운터 증가
    return f"▷eq{inline_replace_func.counter}◁"
    
# 카운터 초기화
inline_replace_func.counter = 0

# 치환
doc = re.sub(inline_pattern, inline_replace_func, doc)
#################################################################

# codebox 찾아서 치환#############################################
# 정규 표현식 패턴 (``` 사이의 모든 것을 포함)
codebox_pattern = r"```.*?```"

codebox_matches = re.findall(codebox_pattern, doc, re.DOTALL)

codebox_dic = {}
for i, match in enumerate(codebox_matches):
    codebox_dic[f'```\ncode{i+1}\n```'] = f'{match}'
# print(codebox_dic)

# 치환 함수
def codebox_replace_func(match):
    codebox_replace_func.counter += 1  # 카운터 증가
    return f"```\ncode{codebox_replace_func.counter}\n```"

# 카운터 초기화
codebox_replace_func.counter = 0

# 치환
doc = re.sub(codebox_pattern, codebox_replace_func, doc, flags=re.DOTALL)
#################################################################

# 빈 텍스트 문서 열기
f = open(cd + f"/before_{language}.txt", 'w', encoding='utf-8')
f.write(doc)
f.close()

f = open(cd + f"/after_{language}.txt", 'w', encoding='utf-8')
f.close()

print(f'1단계: before_{language}.txt 파일을 열어서 번역을 시작하세요.')
print(f'2단계: 번역이 끝나면 after_{language}.txt 파일을 열어서 번역된 문서를 붙여넣으세요.')
print('3단계: 붙여넣기가 끝나면 엔터를 누르세요.')

os.startfile(cd)
os.system("pause")

after = open(cd + f"/after_{language}.txt", 'r', encoding='utf-8')
after_doc = after.read()
after.close()

if after_doc == '':
    print('Error: after_*.txt 파일이 비어있습니다.')
    os.remove(cd + f"/before_{language}.txt")
    os.remove(cd + f"/after_{language}.txt")
    exit()

# 마크다운 양식인지 확인
if after_doc.startswith('```markdown\n'):
    after_doc = after_doc.replace('```markdown\n', '')
    after_doc = after_doc.rstrip('```')
    
# ▶eq{i+1}◀를 다시 equation으로 치환
display_revert_pattern = r"▶eq\d+◀"
after_doc = re.sub(display_revert_pattern, lambda x: display_dic[x.group()], after_doc)

# ▷eq{i+1}◁를 다시 equation으로 치환
inline_revert_pattern = r"▷eq\d+◁"
after_doc = re.sub(inline_revert_pattern, lambda x: inline_dic[x.group()], after_doc)

# code(숫자)를 다시 codebox로 치환
codebox_revert_pattern = r"```\ncode\d+\n```"
after_doc = re.sub(codebox_revert_pattern, lambda x: codebox_dic[x.group()], after_doc)

# 도착언어 마크다운 파일 열기2
md = open(cd + f"/index.{language}.md", 'w', encoding='utf-8')
md.write(front_matter+after_doc)
md.close()

# 임시 텍스트 파일 삭제
os.remove(cd + f"/before_{language}.txt")
os.remove(cd + f"/after_{language}.txt")

print('번역이 완료되었습니다.')
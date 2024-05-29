import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import os
import json

dir = os.path.dirname(os.path.realpath(__file__))

# 블로그 글에서 JSON-LD 스크립트를 통해 저자 정보를 찾는 함수
def find_author_from_jsonld(soup):
    script_tags = soup.find_all('script', type='application/ld+json')
    for script in script_tags:
        try:
            data = json.loads(script.string)
            if data.get("@type") == "BlogPosting":
                author_name = data.get("author", {}).get("name", "저자 미상")
                return author_name
        except json.JSONDecodeError:
            continue
    return "저자 미상"

def find_broken_links(base_url):
    broken_links = []
    try:
        response = requests.get(base_url)
        if response.status_code == 200:
            soup = BeautifulSoup(response.text, 'html.parser')
            author = find_author_from_jsonld(soup)
            links = soup.find_all('a')
            for link in links:
                href = link.get('href')
                link_text = link.text
                if href and not href.startswith('#') and "🎲" not in link_text and "English" not in link_text and not "日本語" in link_text :
                    full_url = urljoin(base_url, href)
                    try:
                        link_response = requests.head(full_url, allow_redirects=True, timeout=5)
                        if link_response.status_code == 404:
                            broken_links.append(f"[{link_text}]({href})")
                    except requests.RequestException:
                        pass
        else:
            print(f"페이지를 불러오는 데 실패했습니다: {base_url}")
    except requests.RequestException:
        pass
    
    return broken_links, author

# for i in range(1, 3631):
#     url = f"https://freshrimpsushi.github.io/ko/posts/{i}/"
#     # 글이 존재하는지 체크합니다.
#     response = requests.head(url)
#     if response.status_code == 200:
#         broken_links = find_broken_links(url)

#         if broken_links:
#             print(f"글 번호 {i}에서 발견된 깨진 링크들:")
#             for link in broken_links:
#                 print(link)
#         else:
#             print(f"글 번호 {i}에서 깨진 링크 없음.")
#     else:
#         print(f"글 번호 {i}는 존재하지 않습니다.")

with open(dir+"/broken_links_report.txt", "w", encoding="utf-8") as report_file:
    for i in range(1, 3637):
        url = f"https://freshrimpsushi.github.io/ko/posts/{i}/"
        response = requests.head(url)
        if response.status_code == 200:
            broken_links, author = find_broken_links(url)
            if broken_links:
                print(f"글 번호 {i}에서 발견된 깨진 링크들:")
                for link in broken_links:
                    print(link)
                    report_file.write(f"{author},{i},{link}\n")
            else:
                print(f"글 번호 {i}에서 깨진 링크 없음.")
        else:
            print(f"글 번호 {i}는 존재하지 않습니다.")

print("깨진 링크 보고서가 'broken_links_report.txt' 파일에 저장되었습니다.")

        
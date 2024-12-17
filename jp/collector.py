import os
import yaml
import csv

# 마크다운 파일이 있는 폴더 경로
root_dir = os.path.dirname(os.path.realpath(__file__))  # 폴더 경로를 설정하세요.

# 결과를 저장할 CSV 파일 경로
csv_file = "metadata.csv"

# CSV 파일에 헤더 작성
header = ['title', 'publishdate', 'author', 'categories', 'idx']

# CSV 파일 열기
with open(csv_file, mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(header)
    
    # 폴더 내 모든 파일을 순회
    for root, dirs, files in os.walk(root_dir):
        for file_name in files:
            if file_name.endswith(".md"):  # 마크다운 파일만 처리
                file_path = os.path.join(root, file_name)
                
                # 마크다운 파일을 열어서 메타데이터 추출
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                    # YAML 헤더 부분 추출
                    if content.startswith('---'):
                        yaml_end = content.find('---', 3)
                        yaml_content = content[3:yaml_end].strip()
                        metadata = yaml.safe_load(yaml_content)
                        
                        # 필요한 메타데이터 추출
                        title = metadata.get('title', '')
                        publishdate = metadata.get('publishdate', '')
                        author = metadata.get('author', '')
                        categories = metadata.get('categories', '')
                        idx = metadata.get('idx', '')
                        
                        # CSV에 한 줄씩 기록
                        writer.writerow([title, publishdate, author, categories, idx])

print("메타데이터 추출 완료. 결과는 'metadata.csv' 파일에 저장되었습니다.")

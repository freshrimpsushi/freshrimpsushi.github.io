using HTTP
using Gumbo
using Cascadia
using JSON3
using FilePaths
using Base.Threads

# 현재 스크립트 파일의 디렉토리 경로를 가져오는 함수
function get_current_dir()
    return dirname(@__FILE__)
end

# JSON-LD 스크립트에서 저자 정보를 찾는 함수
function find_author_from_jsonld(soup)
    script_tags = eachmatch(Selector("script[type='application/ld+json']"), soup.root)
    for script in script_tags
        try
            data = JSON3.read(gettext(script))
            if data["@type"] == "BlogPosting"
                author_name = get(data, "author", Dict("name"=>"저자 미상"))["name"]
                return author_name
            end
        catch e
            continue
        end
    end
    return "저자 미상"
end

# 깨진 링크를 찾는 함수 내에서 HTTP.head 호출 부분 수정
function find_broken_links(base_url)
    broken_links = []
    author = "저자 미상"
    try
        response = HTTP.get(base_url)
        if response.status == 200
            soup = parsehtml(String(response.body))
            author = find_author_from_jsonld(soup)
            links = eachmatch(Selector("a"), soup.root)
            for link in links
                href = get(link.attributes, "href", "")
                link_text = gettext(link)
                if href != "" && !startswith(href, "#") && "🎲" ∉ link_text && "English" ∉ link_text && !("日本語" in link_text)
                    full_url = HTTP.URIs.resolve(HTTP.URI(base_url), HTTP.URI(href))
                    try
                        link_response = HTTP.head(full_url; allow_redirects=true, timeout=5)
                        if link_response.status == 404
                            push!(broken_links, "[$link_text]($href)")
                        end
                    catch e
                        # 404 에러 또는 다른 예외를 여기서 처리
                        if isa(e, HTTP.ExceptionRequest.StatusError) && e.status == 404
                            push!(broken_links, "[$link_text]($href)")
                        end
                    end
                end
            end
        else
            println("페이지를 불러오는 데 실패했습니다: $base_url")
        end
    catch e
        println("요청 중 오류 발생: $e")
    end
    
    return broken_links, author
end

# 보고서 파일에 깨진 링크 기록
function write_broken_links_report()
    dir = get_current_dir()
    report_path = joinpath(dir, "broken_links_report.txt")
    open(report_path, "w") do file
        @threads for i ∈ 1:3637
            url = "https://freshrimpsushi.github.io/ko/posts/$i/"
            response = HTTP.head(url)
            if response.status == 200
                broken_links, author = find_broken_links(url)
                if !isempty(broken_links)
                    println("글 번호 $i에서 발견된 깨진 링크들:")
                    for link in broken_links
                        println(link)
                        write(file, "$author,$i,$link\n")
                    end
                else
                    println("글 번호 $(i)에서 깨진 링크 없음.")
                end
            else
                println("글 번호 $(i)는 존재하지 않습니다.")
            end
        end
    end
    println("깨진 링크 보고서가 'broken_links_report.txt' 파일에 저장되었습니다.")
end

# 보고서 작성 함수 실행
write_broken_links_report()

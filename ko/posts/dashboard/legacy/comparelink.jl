getre(re, str) = getproperty.(collect(eachmatch(re, str)), :match)

category = ARGS[1]
link_ko_ = getre(r"/\d+\)", read("content\\categories\\"*category*"\\_index.md", String))
link_en_ = getre(r"/\d+\)", read("content\\categories\\"*category*"\\_index.en.md", String))
link_jp_ = getre(r"/\d+\)", read("content\\categories\\"*category*"\\_index.jp.md", String))

if length(link_ko_) > length(link_en_)
    for i in 1:length(link_ko_) - length(link_en_)
        push!(link_en_, "")
    end
elseif length(link_ko_) < length(link_en_)
    for i in 1:length(link_en_) - length(link_ko_)
        push!(link_ko_, "")
    end
end

if length(link_ko_) > length(link_jp_)
    for i in 1:length(link_ko_) - length(link_jp_)
        push!(link_jp_, "")
    end
elseif length(link_ko_) < length(link_jp_)
    for i in 1:length(link_jp_) - length(link_ko_)
        push!(link_ko_, "")
    end
end

check_en = [link_ko_[i] == link_en_[i] for i in 1:length(link_ko_)]
check_jp = [link_ko_[i] == link_jp_[i] for i in 1:length(link_ko_)]
using DataFrames

df = DataFrame(; link_ko_, link_en_, check_en, link_jp_, check_jp)
show(stdout, "text/plain", df)
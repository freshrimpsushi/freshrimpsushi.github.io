getre(re, str) = getproperty.(collect(eachmatch(re, str)), :match)
jacard(a, b) = length(intersect(a, b)) / length(union(a, b))

using DataFrames

categories = first.(collect(walkdir("content\\categories")))[2:end]

jacard_en = []
jacard_jp = []
for category in categories
    println(category)
    link_ko_ = getre(r"/\d+\)", read(category * "\\_index.md", String))
    if isfile(category * "\\_index.en.md")
        link_en_ = getre(r"/\d+\)", read(category * "\\_index.en.md", String))
        push!(jacard_en, jacard(link_ko_, link_en_))
    else
        push!(jacard_en, -1)
    end
    if isfile(category * "\\_index.jp.md")
        link_jp_ = getre(r"/\d+\)", read(category * "\\_index.jp.md", String))
        push!(jacard_jp, jacard(link_ko_, link_jp_))
    else
        push!(jacard_jp, -1)
    end
end

df = DataFrame(; categories, jacard_en, jacard_jp)
sort!(df, [:jacard_en, :jacard_jp])

show(stdout, "text/plain", df)
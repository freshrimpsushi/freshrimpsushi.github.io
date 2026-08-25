@time using LaTeXStrings
@time using Plots

cd(@__DIR__)

C = 10000   # 트랜스포머 논문의 상수 C

# ── 그림 1 (3876_1.png): 성분쌍 인덱스 i = 1, 10, 50, 100 의 사인파 (d = 512) ──
# [pe(pos)]_{2i-1} = sin(pos / C^{2(i-1)/d}) 를 위치 pos 의 함수로 (2,2) 레이아웃에 그린다.
d  = 512
ps = 0:0.25:250

subplots = [plot(ps, sin.(ps ./ C^(2(i - 1) / d)),
                title = L"i = %$i", legend = false, linewidth = 1.5,
                xlabel = L"\mathrm{pos}", ylabel = L"[\mathrm{pe}(\mathrm{pos})]_{2i-1}")
            for i in (1, 10, 50, 100)]
p1 = plot(subplots..., layout = (2, 2), dpi = 300, size = (760, 560),
    left_margin = 3Plots.mm, bottom_margin = 3Plots.mm)
savefig(p1, "3876_1.png")

# ── 그림 2 (3876_2.png): pe(1), …, pe(100) 히트맵 (d = 128) ──
# 열 = 위치 pos, 행 = 성분 인덱스(1부터). 아래쪽 성분이 빠르게 진동한다.
d2   = 128
npos = 100

PE = zeros(d2, npos)                    # PE[j, pos] = [pe(pos)]_j
for n in 1:npos, i in 1:d2÷2
    PE[2i - 1, n] = sin(n / C^(2(i - 1) / d2))
    PE[2i, n]     = cos(n / C^(2(i - 1) / d2))
end

p2 = heatmap(1:npos, 1:d2, PE,
    dpi = 300, size = (760, 420), color = :viridis,
    xlabel = L"\mathrm{pos}", ylabel = "component index",
    left_margin = 5Plots.mm, bottom_margin = 5Plots.mm)
savefig(p2, "3876_2.png")

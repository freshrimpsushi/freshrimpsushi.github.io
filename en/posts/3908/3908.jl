using Plots, Random, Printf, Measures, LaTeXStrings

# 정밀도의 의미 (3908_1.png): 분산이 작을수록(정밀도가 클수록) 표본이 평균에 몰린다
# 위  - 분산이 서로 다른 N(0, sigma^2) 세 개의 pdf, 범례에 분산과 정밀도를 함께 표기
# 아래 - 같은 세 분포에서 뽑은 표본 60개씩, 음영은 평균 +- sigma 구간

normpdf(x, s2) = exp(-x^2 / (2s2)) / sqrt(2 * pi * s2)

const VARS = [4.0, 1.0, 0.05]
const COLS = [RGB(.29, .53, .78), RGB(.93, .60, .22), RGB(.85, .33, .29)]
const NS = 60      # 분포마다 뽑을 표본 크기
const XL = 6       # x축 범위

const TFS = 17     # 제목
const LFS = 16     # 축 이름
const GFS = 15     # 범례
const KFS = 13     # 눈금

lab(s2)  = latexstring(@sprintf("\\sigma^{2} = %.2f, \\quad 1/\\sigma^{2} = %.2f", s2, 1 / s2))
ylab(s2) = latexstring(@sprintf("\\sigma^{2} = %.2f", s2))

# ── 위: 확률밀도함수 ──────────────────────────────────────────────────────
x = range(-XL, XL, length = 1201)
p1 = plot(title = L"\mathrm{pdf\ of\ }N(0, \sigma^{2})", titlefontsize = TFS,
          xlabel = L"x", ylabel = L"f(x)",
          xlims = (-XL, XL), ylims = (0, 2.35),
          xlabelfontsize = LFS, ylabelfontsize = LFS, tickfontsize = KFS,
          framestyle = :box, legend = :topright, legendfontsize = GFS)
vline!(p1, [0], c = :gray, ls = :dash, lw = 1.2, label = "")
for (k, s2) in enumerate(VARS)
    plot!(p1, x, normpdf.(x, s2), c = COLS[k], lw = 3, label = lab(s2))
end

# ── 아래: 표본 ────────────────────────────────────────────────────────────
Random.seed!(3908)
p2 = plot(title = latexstring("$NS \\mathrm{\\ samples\\ from\\ each}"), titlefontsize = TFS,
          xlabel = L"x", xlims = (-XL, XL), ylims = (.4, 3.9),
          xlabelfontsize = LFS, tickfontsize = KFS, framestyle = :box, legend = false,
          yticks = (3:-1:1, [ylab(s2) for s2 in VARS]))
vline!(p2, [0], c = :gray, ls = :dash, lw = 1.2)
for (k, s2) in enumerate(VARS)
    y, s = 4 - k, sqrt(s2)
    plot!(p2, Shape([-s, s, s, -s], [y - .32, y - .32, y + .32, y + .32]),
          c = COLS[k], fillalpha = .13, lc = :match)
    plot!(p2, [-XL, XL], [y, y], c = :gray, lw = .8)
    z = s .* randn(NS)
    scatter!(p2, clamp.(z, -XL, XL), y .+ .22 .* (rand(NS) .- .5),
             c = COLS[k], ms = 5, msc = :white, msw = .8, alpha = .85)
end

p = plot(p1, p2, layout = (2, 1), size = (900, 950), dpi = 300,
         left_margin = 12mm, right_margin = 6mm, bottom_margin = 7mm, top_margin = 5mm)
savefig(p, "3908_1.png")
println("saved 3908_1.png")

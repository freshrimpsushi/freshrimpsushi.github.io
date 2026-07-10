# 103_1.png, 103_2.png 생성 스크립트: 디랙 델타 함수
# ① 103_1.png — 원점의 좁고 높은 스파이크(좁은 가우시안)로 그린 델타 함수의 직관
# ② 103_2.png — 넓이 1을 유지한 채 좁고 높아지는 직사각형 Rₙ·삼각형 Tₙ 함수열 (1행 2열)
using Plots
using LaTeXStrings

# ① 103_1.png: 좁은 가우시안 스파이크 (σ = 0.05), 곡선 아래 채움 + δ(x) 주석
σ = 0.05
x = range(-2, 2, length = 2000)
spike = @. exp(-x^2 / (2σ^2)) / (σ * √(2π))
plot(x, spike,
    linewidth = 3, color = :royalblue, fillrange = 0, fillalpha = 0.2,
    legend = false, size = (600, 400), dpi = 300,
    framestyle = :origin, yticks = false)
annotate!(0.45, maximum(spike) * 0.85, text(L"\delta(x)", 18))
savefig(joinpath(@__DIR__, "103_1.png"))

# ② 103_2.png: 함수열 Rₙ(왼쪽)·Tₙ(오른쪽), n = 1, 2, 3
# 왼쪽 — 높이 n, 폭 1/n 직사각형 Rₙ
p1 = plot(xlims = (-1.2, 1.2), ylims = (0, 3.4),
    framestyle = :origin, legend = :topright, legendfontsize = 12,
    aspect_ratio = 1)
for n in 1:3
    w = 1 / 2n                       # 직사각형의 반폭
    plot!(p1, [-1.2, -w, -w, w, w, 1.2], [0, 0, n, n, 0, 0],
        linewidth = 3, label = latexstring("R_{$n}(x)"))
end

# 오른쪽 — 높이 n, 밑변 2/n 이등변삼각형 Tₙ
p2 = plot(xlims = (-1.2, 1.2), ylims = (0, 3.4),
    framestyle = :origin, legend = :topright, legendfontsize = 12,
    aspect_ratio = 1)
for n in 1:3
    b = 1 / n                        # 밑변의 절반
    plot!(p2, [-1.2, -b, 0, b, 1.2], [0, 0, n, 0, 0],
        linewidth = 3, label = latexstring("T_{$n}(x)"))
end

plot(p1, p2, layout = (1, 2), size = (760, 520), dpi = 300)
savefig(joinpath(@__DIR__, "103_2.png"))

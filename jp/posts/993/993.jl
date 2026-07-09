# 993_1.png 생성 스크립트: 입력 벡터(로짓)와 소프트맥스 출력(확률분포)의 대조 막대그래프
using Plots
using LaTeXStrings

x = [2.0, -0.5, 0.5, -1.0, 3.0]
σ = exp.(x) ./ sum(exp.(x))

p1 = bar(1:5, x,
    label = L"\mathbf{x}", legend = :topleft, legendfontsize = 12,
    xticks = (1:5, [L"x_{%$i}" for i in 1:5]),
    color = :steelblue, framestyle = :semi)
hline!(p1, [0], color = :black, label = false)

p2 = bar(1:5, σ,
    label = L"\sigma(\mathbf{x})", legend = :topleft, legendfontsize = 12,
    xticks = (1:5, [L"\sigma_{%$i}(\mathbf{x})" for i in 1:5]),
    ylims = (0, 1.05), color = :orange, framestyle = :origin)
hline!(p2, [1], linestyle = :dash, color = :gray, label = false)

plot(p1, p2, layout = (1, 2), size = (800, 350), dpi = 200)

savefig("993_1.png")

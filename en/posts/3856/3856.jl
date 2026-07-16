# 3856_1.png 생성 스크립트: ReLU와 Leaky ReLU의 개형 비교
# ReLU는 royalblue 실선, Leaky ReLU는 tomato 점선 (α = 0.1)
using Plots
using LaTeXStrings

relu(x) = max(0, x)
leakyrelu(x; α = 0.1) = max(α * x, x)

x = range(-4, 4, length = 400)
plot(x, relu.(x),
    linewidth = 3, color = :royalblue, label = L"\mathrm{ReLU}(x)",
    legend = :topleft, legendfontsize = 12,
    size = (600, 400), dpi = 200, framestyle = :origin)
plot!(x, leakyrelu.(x),
    linewidth = 3, color = :tomato, linestyle = :dash,
    label = L"\mathrm{LeakyReLU}(x), \alpha = 0.1")

savefig("3856_1.png")

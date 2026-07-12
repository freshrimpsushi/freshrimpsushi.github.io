# 3854_1.png 생성 스크립트: 하이퍼볼릭 탄젠트와 그 도함수의 개형
using Plots
using LaTeXStrings

x = range(-5, 5, length = 400)
plot(x, tanh.(x),
    linewidth = 3, label = L"\tanh(x)", legend = :topleft, legendfontsize = 12,
    size = (600, 400), dpi = 200, framestyle = :origin)
plot!(x, sech.(x).^2, linewidth = 3, label = L"\tanh'(x)")
hline!([1], linestyle = :dash, color = :gray, label = false)
hline!([-1], linestyle = :dash, color = :gray, label = false)

savefig("3854_1.png")

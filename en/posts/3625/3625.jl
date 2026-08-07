using Plots

function Mp(x, p)
    if p == -Inf
        return minimum(x)
    elseif p == Inf
        return maximum(x)
    elseif p == 0
        return prod(x)^(1 / length(x))
    else
        return (sum(x .^ p) / length(x))^(1 / p)
    end
end

plist = [(-Inf, "min (p = -∞)", :purple),
         (-1, "harmonic (p = -1)", :blue),
         (0, "geometric (p = 0)", :green),
         (1, "arithmetic (p = 1)", :orange),
         (2, "RMS (p = 2)", :red),
         (Inf, "max (p = ∞)", :brown)]

# 그림 1: 두 수 1과 x의 일반화 평균 M_p(1, x)를 x의 함수로
xs = range(0, 4, length = 401)
p1 = plot(xlabel = "x", ylabel = "Mₚ(1, x)",
    title = "generalized means of 1 and x",
    legend = :topleft, size = (600, 450), dpi = 300,
    left_margin = 4Plots.mm, bottom_margin = 4Plots.mm)
for (p, name, c) in plist
    plot!(p1, xs, [Mp([1.0, t], p) for t in xs],
        label = name, color = c, linewidth = 2)
end
savefig(p1, "3625_1.png")

# 그림 2: 10차원 데이터 막대그래프 + 대표적인 p-평균 수평선
x = [2.0, 7.0, 1.5, 4.0, 9.0, 3.0, 5.5, 8.0, 2.5, 6.0]
n = length(x)

p2 = bar(1:n, x,
    label = "data", xlabel = "i", ylabel = "xᵢ",
    alpha = 0.5, color = :lightgray, legend = :topleft,
    title = "means of the data",
    ylims = (0, 10), xlims = (0, 11),
    size = (760, 450), dpi = 300,
    left_margin = 4Plots.mm, bottom_margin = 4Plots.mm,
    right_margin = 32Plots.mm)
for (p, name, c) in plist
    m = Mp(x, p)
    hline!(p2, [m], label = "", color = c, linewidth = 2)
    annotate!(p2, 11.15, m, text(name, 9, :left, c))
end
savefig(p2, "3625_2.png")

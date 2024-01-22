using Plots
using StatsPlots

cd = @__DIR__

p₁ = plot(rand(10), mc = :red, dpi = 300, title = "p₁", lw = 4, size = (600,200))

savefig(p₁, cd*"/3601_1.png")


st = [:line :scatter :barhist :steppre :scatterhist :bar]

x = rand(20)
y = repeat(x, outer = (1, length(st)))

plot(y, seriestype = st, layout = 6, dpi = 300, size = (900, 600), 
    mc = :purple, lc = :darkgreen, fc = :skyblue, lw = 3, ms = 7,
    title = reshape([":$(st[i])" for i ∈ 1:length(st)], (1,:)), bins = 10,
    bottom_margin = 30Plots.px)
savefig(cd*"/3601_2.png")

plot(rand(20, 3), layout = (3,1), seriestype = [:scatter :line :bar],
    markeralpha = 0.5, mc = :red,
    la = 0.5,          lc = :green,
    fα = 0.5,          fc = :blue,
    lw = 3, ms = 7, dpi = 300
)


p = plot(rand(20, 3), layout = (3,1), seriestype = [:scatter :line :bar],
    markeralpha = 0.5, mc = :red,
    la = 0.5,          lc = :green,
    fα = 0.5,          fc = :blue,
    lw = 3, ms = 7, dpi = 300
)
savefig(p, cd*"/3601_3.png")

p2
p2.series_list[2][:linealpha] = 1
p2.series_list[1][:markeralpha] = 1
p2.series_list[3][:fillalpha] = 1
savefig(p2, cd*"/3601_4.png")
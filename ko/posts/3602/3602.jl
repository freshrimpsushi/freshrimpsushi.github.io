using Plots

cd = @__DIR__

p₁ = plot(rand(10), lc = :red, lw = 4)
p₂ = scatter(rand(10), mc = :blue, ms = 7)
p₃ = bar(rand(10), fc = :green)
plot(p₁, p₂, p₃,
     layout = (3, 1),
     dpi = 300, size = (600, 450),
     title = ["p₁" "p₂" "p₃"],
     legend = :none,
     bottom_margin = [25Plots.px 25Plots.px 0Plots.px],
)
savefig(cd * "/3602_1.png")


p₄ = plot(rand(10), lw = 4)
p₅ = plot(rand(10), lw = 4)
p₆ = plot(rand(10), lw = 4)
plot(p₄, p₅, p₆,
     layout = (3, 1),
     linecolor = [:brown :purple :orange],
     dpi = 300, size = (600, 450),
     title = ["p₄" "p₅" "p₆"],
     legend = :none,
     bottom_margin = [25Plots.px 25Plots.px 0Plots.px],
)
savefig(cd * "/3602_2.png")

p₇ = plot(rand(10), lw = 4)
p₈ = scatter(rand(10), ms = 7)
p₉ = bar(rand(10))
p = plot(p₇, p₈, p₉,
        layout = (3, 1),
        dpi = 300, size = (600, 450),
        title = ["p₇" "p₈" "p₉"],
        legend = :none,
        bottom_margin = [25Plots.px 25Plots.px 0Plots.px],
)
p.series_list[1][:linecolor] = :goldenrod1
p.series_list[2][:markercolor] = :olivedrab3
p.series_list[3][:fillcolor] = :hotpink3
display(p)
savefig(p, cd * "/3602_3.png")

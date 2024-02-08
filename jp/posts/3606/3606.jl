using Plots

cd = @__DIR__

x = 0:0.01:2π

plot(x, sin.(x), label = " sin x", lw = 3)
plot!(x, exp.(x), label = " exp x", lw = 3, dpi = 300, size = (600, 200))
savefig(joinpath(cd, "3606_1.png"))


plot(x, sin.(x), label = " sin x", lw = 3, ylabel = "sin x", legend = :topleft, left_margin = 20Plots.px, ylims = (-Inf, 1.5))
plot!(twinx(), x, exp.(x), label = " exp x", legend = :topright, ylims = (-Inf, 700),
    
    right_margin = 20Plots.px,
    lw = 3, dpi = 300, size = (600, 200), lc = palette(:tab10)[2], ylabel = "exp x")
savefig(joinpath(cd, "3606_2.png"))



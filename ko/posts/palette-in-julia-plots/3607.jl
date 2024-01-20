using Plots

cd = @__DIR__

palette(:default)

x = 0:0.01:2π
plot([x -> sin(x - a) for a in range(0, π, length = 5)], 0, 2π,
    lw = 4, dpi = 300, size = (600, 200))
savefig(cd*"/3607_2.png")


palette(:rainbow)

plot([x -> sin(x - a) for a in range(0, π, length = 5)], 0, 2π,
    lw = 4, dpi = 300, size = (600, 200), palette = palette(:rainbow))
savefig(cd*"/3607_4.png")

palette([:blue, :orange], 10)

palette([RGB(0.5, 0.6, 0.2), RGB(1.0, 0.2, 0.9)], 10)

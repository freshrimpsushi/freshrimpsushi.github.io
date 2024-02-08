using Plots

cd = @__DIR__

plot(rand(10, 3), layout = (3, 1), gridalpha = [0.1 0.5 1], lw = 3,
    dpi = 300, label = "", legend_title = ["α = 0.1" "α = 0.5" "α = 1"])
savefig(joinpath(cd, "3604_1.png"))


plot(rand(10, 3), layout = (3, 1), gridalpha = 1, lw = 3,
    fgcolor_grid = [:red :green :orange],
    dpi = 300, label = "", legend_title = [":red" ":green" ":orange"])
savefig(joinpath(cd, "3604_2.png"))


plot(rand(10, 3), layout = (3, 1), lw = 3,
    grid_lw = [0.5 5 10],
    dpi = 300, label = "", legend_title = ["grid_lw = 0.5" "grid_lw = 5" "grid_lw = 10"])
savefig(joinpath(cd, "3604_3.png"))


plot(rand(10, 2), layout = 2, gridstyle = [:solid :dash], ga = 1,
    dpi = 300, 
    size = (600, 200), lw = 3, label = "", legend_title = ["grid_ls = :solid" "grid_ls = :dash"])
savefig(joinpath(cd, "3604_4.png"))

plot(plot(rand(10)),
     plot(rand(10), grid = :x),
     plot(rand(10), grid = :y),
     plot(rand(10), grid = false),
     label = "",
     legend_title = ["defalut" "grid = :x" "grid = :y" "grid = false"],
     gridalpha = 0.5,
     dpi = 300, lw = 3)
savefig(joinpath(cd, "3604_5.png"))


plot(plot(rand(10)),
     plot(rand(10), minorgrid = true),
     gridalpha = 0.8,
     minorgridalpha = 0.2,
     label = "",
     legend_title = ["" "with minorgrid"],
     dpi = 300, lw = 3, size = (600, 200))
savefig(joinpath(cd, "3604_6.png"))
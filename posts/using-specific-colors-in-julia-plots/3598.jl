using Plots

cd = @__DIR__

# p = plot(randn(50, 6),
#         seriescolor = [:red :hotpink1 :purple3 "blue" "lime" "brown4"],
#         label = [" :red" " :hotpink1" " :purple3" " \"blue\"" " \"lime\"" " \"brown4\""],
#         seriestype = [:line :scatter :histogram :shape :sticks :steppre],
#         layout = (3,2),
#         lw = [3 3 1 1 3 3],
#         msw = 0, bar_edges = false, dpi = 300)

# savefig(p, cd*"/3598.png")


p2 = plot(rand(50, 2),
        seriescolor = [colorant"#FF0000" colorant"#00f"],
        label = [" colorant\"#FF0000\"" " colorant\"#00f\""],
        layout = 2, lw = 4, dpi = 300
)

savefig(p2, cd*"/3598_2.png")


# p3 = plot(rand(20, 2),
#     seriescolor = [colorant"rgb(255, 0, 0)" colorant"rgba(0, 0, 255, 0.5)"],
#     label = [" colorant\"rgb(255, 0, 0)\"" " colorant\"rgba(0, 0, 255, 0.5)\""],
#     layout = 2, lw = 4, dpi = 300)

# savefig(p3, cd*"/3598_3.png")
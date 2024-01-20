using Plots
cd = @__DIR__

x = randn(10)

plot(plot(x, guidefontcolor = :red),
     plot(x, x_guidefontcolor = :red),
     plot(x, y_guidefontcolor = :red),
     xlabel = "x label",
     ylabel = "y label",
     title = ["guidefontcolor" "x_guidefontcolor" "y_guidefontcolor"],
     layout = (3, 1),
     dpi = 300, size = (600, 450),
     legend = :none,
     bottom_margin = [25Plots.px 25Plots.px 0Plots.px],
)
savefig(cd * "/3490_1.png")


plot(plot(x, foreground_color_border = :red),
     plot(x, x_foreground_color_border = :red),
     plot(x, y_foreground_color_border = :red),
     xlabel = "x label",
     ylabel = "y label",
     title = ["foreground_color_border" "x_foreground_color_border" "y_foreground_color_border"],
     layout = (3, 1),
     dpi = 300, size = (600, 450),
     legend = :none,
     bottom_margin = [25Plots.px 25Plots.px 0Plots.px],
)
savefig(cd * "/3490_2.png")


plot(plot(x, foreground_color_axis = :red),
     plot(x, x_foreground_color_axis = :red),
     plot(x, y_foreground_color_axis = false),
     xlabel = "x label",
     ylabel = "y label",
     title = ["foreground_color_axis" "x_foreground_color_axis" "y_foreground_color_axis"],
     layout = (3, 1),
     dpi = 300, size = (600, 450),
     legend = :none,
     bottom_margin = [25Plots.px 25Plots.px 0Plots.px],
)
savefig(cd * "/3490_3.png")


plot(plot(x, foreground_color_text = :red),
     plot(x, x_foreground_color_text = :red),
     plot(x, y_foreground_color_text = false),
     xlabel = "x label",
     ylabel = "y label",
     title = ["foreground_color_text" "x_foreground_color_text" "y_foreground_color_text"],
     layout = (3, 1),
     dpi = 300, size = (600, 450),
     legend = :none,
     bottom_margin = [25Plots.px 25Plots.px 0Plots.px],
)
savefig(cd * "/3490_4.png")
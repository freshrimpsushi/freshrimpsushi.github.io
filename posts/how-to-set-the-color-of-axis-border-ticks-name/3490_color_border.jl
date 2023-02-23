using Plots

x = randn(10)
p = plot(x, xlabel="x-axis", ylabel="y-axis", label="", color=:black)
p1 = plot(p, x_guidefontcolor=:red, y_guidefontcolor=:green, title="guidefontcolor", bottom_margin=10*Plots.mm) 
p2 = plot(p, x_foreground_color_axis=:red, y_foreground_color_axis=:green, title="foreground_color_axis", left_margin=10*Plots.mm)
p3 = plot(p, x_foreground_color_text=:red, y_foreground_color_text=:green, title="foreground_color_text")
p4 = plot(p, x_foreground_color_border=:red, y_foreground_color_border=:green, title="foreground_color_border")

plot(p1,p2,p3,p4, size=(728,500))

cd = @__DIR__
savefig(cd * "/3490.png")
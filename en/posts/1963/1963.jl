using Plots

t = LinRange(0, 2π, 100)

anim = @animate for i in 1:100
    scatter([cos(t[i])], [sin(t[i])], xlims=(-1.1, 1.1), ylims=(-1.1, 1.1), framestyle = :origin, legend=:none, aspect_ratio=:equal, size=(400,400), dpi=300,
    title = "t = $(round(t[i], digits=2))", color = :red, )
    xx = round(cos(t[i]), digits=2)
    yy = round(sin(t[i]), digits=2)
    annotate!([(0.1, 0.5, text("(x,y)=($xx, $yy)", 10, :black, :left))])
end
gif(anim, "1963_1.gif")


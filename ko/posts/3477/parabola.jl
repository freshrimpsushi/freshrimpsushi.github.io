using Plots
cd = @__DIR__
x = Vector(LinRange(0,3,100))
y₊ = sqrt.(4x)
y₋ = -sqrt.(4x)

anim = @animate for i ∈ 1:length(x)
    plot(x[1:i], y₊[1:i], legend=:none, xlims=(-2,3), ylims=(-4,4))
    plot!(x[1:i], y₋[1:i], legend=:none)
end
gif(anim, cd*"/example.gif", fps = 30)

p = plot( xlims=(-2,3), ylims=(-4,4), framestyle=:zerolines, color=:grey)
plot!(x_foreground_color_border=:grey, y_foreground_color_border=:grey)
vline!([-1], color=:black, label=:none)



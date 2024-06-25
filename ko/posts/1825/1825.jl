using Plots
using LaTeXStrings

t = LinRange(-1, 1, 100)
cd = @__DIR__
anim = @animate for i in 1:100
    plot(cosh.(t), sinh.(t), color = :black, lw = 2)
    plot!(-cosh.(t), sinh.(t), color = :black, lw = 2)
    scatter!([cosh(t[i])], [sinh(t[i])], framestyle = :origin, aspect=:equal, legend=:none, size=(400,400), dpi=300,
    title = "t = $(round(t[i], digits=2))", color = :orange, xlims=(-1.60,1.60), ylims=(-1.20,1.20), ms=6)
    scatter!([-cosh(t[i])], [sinh(t[i])], color = :blue, ms=6)
    xx = round(cosh(t[i]), digits=2)
    yy = round(sinh(t[i]), digits=2)
    annotate!([(0.2, 0.7, text(L"(\cosh t, \sinh t)", 10, :orange, :left))])
    annotate!([(-0.1, -0.7, text(L"(-\cosh t, \sinh t)", 10, :blue, :right))])
end
gif(anim, cd*"/1825_1.gif", fps = 25)

sinh(1)
cosh(1)
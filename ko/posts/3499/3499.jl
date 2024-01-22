using Plots
cd = @__DIR__

# Fig. 1
x = LinRange(-1., 1, 100)
t = LinRange(0., 0.35, 200)'

u1 = @. sin(π*x)*exp(- π^2 * t)
heatmap(t', x, u1, xlabel="t", ylabel="x", title="Fig. 1")
savefig(cd*"/fig1.png")

# Fig. 2
U(t,x) = sin(π*x)*exp(- π^2 * t)
x = LinRange(-1., 1, 100)
t = LinRange(0., 0.35, 200)'

X = x * fill!(similar(t), 1)
T = fill!(similar(x), 1) * t

u2 = U.(T,X)
heatmap(t', x, u2, xlabel="t", ylabel="x", title="Fig. 2")
savefig(cd*"/fig2.png")

# gif 1
x = reshape(LinRange(-1., 1, 100), (100,1,1))
y = reshape(LinRange(-1., 1, 100), (1,100,1))
t = reshape(LinRange(0.,0.35, 200), (1,1,200))

u3 = @. exp(-x^2) * exp(-2y^2) * exp(- π^2 * t)
anim = @animate for i ∈ 1:200
    surface(u3[:,:,i], zlims=(0,1), clim=(-1,1), title="Anim. 1")
end
gif(anim, cd*"/anim1.gif", fps=30)
using Plots
cd = @__DIR__

U(t,x) = sin(π*x)*exp(- π^2 * t)
x = LinRange(-1., 1, 100)
t = LinRange(0., 0.35, 200)'

# Fig. 1
X = x * fill!(similar(t), 1)
T = fill!(similar(x), 1) * t

u1 = U.(T,X)
heatmap(t', x, u1, title="Fig 1")
savefig(cd*"/fig1.png")

# kron
using LinearAlgebra

X = kron(x, ones(size(t)))
T = kron(ones(size(x)), t)

u2 = U.(T,X)
heatmap(t', x, u2, title="Fig 2")
savefig(cd*"/fig2.png")

u1 == u2

# 3d
U(x,y,t) = (1/4) * exp(-x^2) * exp(-2y^2) * exp(- π^2 * t)

x = LinRange(-2., 2, 100)
y = LinRange(-2., 2, 100)
t = LinRange(0.,0.35, 50)

X = getindex.(Iterators.product(x, y, t), 1)
Y = getindex.(Iterators.product(x, y, t), 2)
T = getindex.(Iterators.product(x, y, t), 3)

u3 = U.(X,Y,T)

anim = @animate for i ∈ 1:50
    surface(u3[:,:,i], zlims=(0,0.5), clim=(0,0.3), title="Anim. 1")
end
gif(anim, cd*"/anim1.gif", fps=10)
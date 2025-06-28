using DifferentialEquations, Plots, LinearAlgebra, Distributions
using Interpolations

x = LinRange(0, 40, 100)
k(x1, x2, ℓ) = exp(-abs2(x1 - x2) / (2 * ℓ^2))
Σ = [k(x[i],x[j],4) for i ∈ 1:100, j ∈ 1:100]
ϵ = 1e-6
Σ += ϵ*I
dist = MvNormal(zeros(100), Σ)
u = rand(dist)
plot(x, u)

u_itp = LinearInterpolation(x, u)

f(s, u, t) = u(t)

s0 = 1.0
tspan = (0.0, 40.0)

prob = ODEProblem(f, s0, tspan, u_itp)
sol = solve(prob)

plot(sol, lw = 5, label = "numerical solution", dpi=300, idxs=1)

plot!(LinRange(0, 40, 100), t -> x(t), lw=3, ls=:dash, lc=:red, label="exact solution")

using DifferentialEquations
using Plots, LinearAlgebra, Distributions
using Interpolations



u_itp = interpolate(u, BSpline(Cubic(Line())), OnGrid())

u_itp(1.2)
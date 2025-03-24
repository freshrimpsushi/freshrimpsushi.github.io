using DifferentialEquations
using Plots

f(u, p, t) = u + p(t)
function g!(du, u, p, t)
    du[1] = u[1] + p(t)
end

u0 = 0.0
tspan = (0.0, 1.0)
p(t) = sin(t)

prob = ODEProblem(f, u0, tspan, p)
sol = solve(prob)

plot(sol, lw = 5, label = "numerical solution", dpi=300)
plot!(LinRange(0, 1, 100), t -> -(1/2)*(sin(t) + cos(t) - exp(t)), lw=3, ls=:dash, lc=:red, label="exact solution")
savefig("1083_1.png")

########################

function forced_harmonic_oscillation!(dx, x, p, t)
    dx[1] = x[2]
    dx[2] = -2x[2] -0.5x[1] + p(t)
end

x0 = [0.0, 1.0]
tspan = (0.0, 40.0)
p(t) = cos(2t)

prob2 = ODEProblem(forced_harmonic_oscillation!, x0, tspan, pp_itp)
sol2 = solve(prob2)

x(t) = 0.6564172054223187exp((-1+sqrt(0.5))*t) -0.5325234001125843exp((-1-sqrt(0.5))*t)-(14/113)*cos(2t) + (16/113)*sin(2t)
pp = p.(0:0.1:40)
pp_itp = interpolate(xx, BSpline(Cubic(Line())), OnGrid())

plot(sol2, lw = 5, label = "numerical solution", dpi=300, idxs=1)
plot!(LinRange(0, 40, 100), t -> x(t), lw=3, ls=:dash, lc=:red, label="exact solution")

savefig("1083_2.png")
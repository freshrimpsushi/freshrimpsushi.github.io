using DifferentialEquations, Plots

f(u, p, t) =  4u
u0 = 0.5
tspan = (0.0, 1.0)

problem = ODEProblem(f, u0, tspan)
@time solution = solve(problem)

using Plots
p1 = plot(solution, title="plot(solution)")
p2 = plot(solution.t, solution.u, title="plot(solution.t, solution.u)")
plot(p1, p2, layout = (2, 1), dpi=300)
savefig("1098_1.png")

plot(solution, label="solver", lw=4)
plot!(LinRange(0,1,100), t->0.5*exp(4t), label="exact", lw=3, ls=:dash, lc=:red, dpi=300)
savefig("1098_2.png")

solve(problem, Tsit5(), saveat=0.05, abstol=1e-8)

# ODE system
function lorenz!(du, u, p, t)
    du[1] = 10(u[2] - u[1])
    du[2] = u[1]*(28-u[3]) - u[2]
    du[3] = u[1]*u[2] - (8/3)u[3]
end

u0 = [1.0, 1.0, 1.0]
tspan = (0.0, 100)
prob = ODEProblem(lorenz!, u0, tspan)
sol = solve(prob)

plot(sol, idxs=(1,2,3), dpi=100)
savefig("1098_3.png")
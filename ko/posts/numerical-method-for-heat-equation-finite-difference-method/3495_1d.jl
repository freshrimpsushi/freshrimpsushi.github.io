using Plots
using LinearAlgebra

function Solver_Heat_1d(Δt, T, x, f, g)
    # Δt: time step,    T: last time,   x: space vector
    # f: initial value,  g: boundary value
    
    t = Vector(0:Δt:T)
    n = length(t)
    ℓ = length(x)
    Δx = x[2]-x[1]
    μ = Δt/((Δx)^2)
    μ = Δt/((Δx)^2)

    U = zeros(ℓ,n)
    U[1,:] .= g[1]
    U[end,:] .= g[end]

    U[:,1] = f

    for i ∈ 2:n
        U[2:end-1, i] = (1-2μ)*U[2:end-1, i-1] + μ*(U[1:end-2, i-1] + U[3:end, i-1])                     
    end
    return U
end

function ref_sol(x, t, exact_sol)
    xt =[kron(ones(length(t)),x);; kron(t,ones(length(x)))]
    ref_U = reshape(exact_sol(xt),length(x),length(t))
    return ref_U
end

function results(t, x, U, ref_U, μ)
    h1 = heatmap(t, x, U, colormap=:viridis, clim=(-1,1))
    # xlabel!("time [0, $(round(t[end], digits=2)) ]")
    # ylabel!("space [$(x[1]),  $(x[end])]")
    title!("FDM solution")

    h2 = heatmap(t, x, ref_U, colormap=:viridis, clim=(-1,1))
    title!("exact solution")

    h3 = heatmap(t, x, U - ref_U, colormap=:viridis)
    title!("error")

    h4 = heatmap(framestyle=:none)
    annotate!([0.5],[0.5], text("μ = $(round(μ, digits=3))", 30))

    plot(h1, h2, h3, h4, size=(1500,750))
end

begin 
    for μ ∈ [0.5, 0.51]
        x = Vector(LinRange(-1., 1, 100))
        Δx = x[2]-x[1]
        initial_f = sin.(π*x)
        Δt = μ*((Δx)^2)
        T = 0.35
        bdry_g = [0.0, 0.0]
        t = Vector(0:Δt:T)

        exact_sol(xt) = sin.(π*xt[:,1]) .* exp.(- (π)^2 * xt[:,2])
        ref_u = ref_sol(x, t, exact_sol)
        U = Solver_Heat_1d(Δt, T, x, initial_f, bdry_g)
        results(t, x, U, ref_u, μ)
        savefig("mu=" * string(μ) * ".png") 
    end
end



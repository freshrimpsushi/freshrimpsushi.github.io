using Plots

cd = @__DIR__

function Solver_Heat_2d(Δt, T, x, f)
    # Δt: time step,    T: last time,   x: space vector
    # f: initial value
    
    t = Vector(0:Δt:T)
    n = length(t)
    ℓ = length(x)
    Δx = x[2]-x[1]
    μ = Δt/((Δx)^2)

    U = zeros(ℓ,ℓ,n)
    U[:,:,1] = f

    for i ∈ 2:n
        U[2:end-1, 2:end-1, i] = (1-4μ)*U[2:end-1, 2:end-1, i-1] + μ*(U[1:end-2, 2:end-1, i-1] + U[3:end, 2:end-1, i-1] + U[2:end-1, 1:end-2, i-1] + U[2:end-1, 3:end, i-1])                     
    end

    return U
end

x = range(-2., stop=2, length=100)'
y = range(-2., stop=2, length=100)

initial_f = @. (1/4)exp(-x^2) * exp(-y^2) 

Δx = x[2]-x[1]
Δt = 0.49*((Δx)^2)/2
T = 1.0

U = Solver_Heat_2d(Δt, T, x, initial_f)

anim = @animate for i ∈ range(1, stop=size(U)[3], step=100)
    surface(U[:,:,i], zlims=(0,0.5), camera=(30,30), colorbar=:none, showaxis = false, grid=false, size=(500,500))
end

gif(anim, cd*"/2d.gif", fps=10)
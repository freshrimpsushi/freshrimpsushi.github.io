using Plots

x = LinRange(-1, 1, 300)
Δx = x[2] - x[1]

t = LinRange(0, 4, 600)
Δt = t[2] - t[1]

μ = Δt / Δx

U = zeros(length(x), length(t))

U[:, 1] = exp.(-30 * x.^2)
U[:, 2] = exp.(-30 * x.^2)

for i ∈ 3:length(t)
    U[2:end-1, i] = (μ^2)*U[3:end, i-1] + 2(1-μ^2)*U[2:end-1, i-1] + (μ^2)*U[1:end-2, i-1] - U[2:end-1, i-2]
end

heatmap(U)

anim = @animate for i ∈ 1:length(t)
    plot(x, U[:, i], xlims=(-1, 1), ylims=(-2,2), legend=false)
end
gif(anim, cd*"./1628_2.gif", fps=50)

x2 = LinRange(-1, 1, 300)
Δx2 = x2[2] - x2[1]

t2 = LinRange(0, 1, 149)
Δt2 = t2[2] - t2[1]

μ2 = Δt2 / Δx2

U2 = zeros(length(x2), length(t2))

U2[:, 1] = exp.(-30 * x.^2)
U2[:, 2] = exp.(-30 * x.^2)

# U[Int(length(x)/4):3Int(length(x)/4), 1] = sin.(LinRange(0, π, 151))
# U[Int(length(x)/4):3Int(length(x)/4), 2] = sin.(LinRange(0, π, 151))

for i ∈ 3:length(t2)
    U2[2:end-1, i] = (μ2^2)*U2[3:end, i-1] + 2(1-μ2^2)*U2[2:end-1, i-1] + (μ2^2)*U2[1:end-2, i-1] - U2[2:end-1, i-2]
    
    # U[1, i] = (μ^2)*U[2, i-1] + 2(1-μ^2)*U[1, i-1] - U[1, i-2]
    # U[end, i] = 2(1-μ^2)*U[end, i-1] + (μ^2)*U[end-1, i-1] - U[end, i-2]
end

heatmap(U2)
anim2 = @animate for i ∈ 1:length(t2)
    plot(x, U2[:, i], xlims=(-1, 1), ylims=(-2,2), legend=false)
end
gif(anim2, fps=50) 

anim3 = @animate for i ∈ 1:length(t2)
    p1 = plot(x, U[:, i], xlims=(-1, 1), ylims=(-1.5,1.5), legend=false, title="μ=0.5")
    p2 = plot(x, U2[:, i], xlims=(-1, 1), ylims=(-1.5,1.5), legend=false, title="μ=1.01")
    plot(p1, p2, layout=(1,2), dpi=300, size=(728,400))
end
cd = @__DIR__
gif(anim3, cd*"./1628_1.gif", fps=50) 
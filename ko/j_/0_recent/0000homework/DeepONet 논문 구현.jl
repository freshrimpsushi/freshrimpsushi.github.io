using DifferentialEquations
using Plots
using Flux
using Distributions
using LinearAlgebra
using Interpolations

u_val = sin.(0:0.05:2π)
u = t -> u_val(t)

function linear_ode!(ds, s, p, t)
    ds[1] = p(t)
end

sensors = LinRange(0, 1, 100)

sensors = rand(m)
sensors = sort(sensors)
k(x1, x2, ℓ) = exp(-abs2(x1 - x2) / (2 * ℓ^2))
Σ = [k(sensors[i],sensors[j],0.1) for i ∈ 1:100, j ∈ 1:100]
ϵ = 1e-6
Σ += ϵ*I
dist = MvNormal(zeros(100), Σ)
u = rand(dist)
plot(u)

s0 = 0.0
tspan = (0, 1)

prob = ODEProblem(linear_ode!, s0, tspan, u)
sol = solve(linear_ode!, s0, saveat=sensors)


struct DeepONet
    branch::Chain
    trunk::Chain
    bias::AbstractArray{Float32}
end

Flux.@functor DeepONet

function (nn::DeepONet)(u, y)
    b_k = nn.branch(u)
    t_k = nn.trunk(y)
    return sum(b_k .* t_k, dims=1) .+ nn.bias
end

function generate_mlp(layers)
    return Chain(
                [Dense(layers[i], layers[i+1], relu) for i in 1:length(layers)-2]...,
                Dense(layers[end-1], layers[end])
                )
end

p = 50      # dimemsion of trunk network's output or number of basis functions
m = 200     # number of sensors

branch_layers = [m, 100, 100, 100, 100, p]
branch = generate_mlp(branch_layers)

trunk_layers  = [1, 100, 100, 100, 100, p]
trunk = generate_mlp(trunk_layers)
bias = randn(Float32, 1)

deeponet = DeepONet(branch, trunk, bias) |> gpu

s0       = 0                        # initial condition
Num_u    = 3500                     # number of samples for input functions u
Num_y    = 50                       # dimension of the variable y for output function Gu
inputs_y = LinRange(0, 1, Num_y) # sampling points for y

M       = 1  # bound of domain
sensors = rand(m)
sensors = sort(sensors)

k(x1, x2, ℓ) = exp(-abs2(x1 - x2) / (2 * ℓ^2))
Σ = [k(sensors[i],sensors[j],1) for i ∈ 1:100, j ∈ 1:100]
ϵ = 1e-6
Σ += ϵ*I
dist = MvNormal(zeros(100), Σ)
u = [rand(dist) for _ ∈ 1:Num_u] 




dataloader = Flux.DataLoader((inputs_U, inputs_Y, target_S), batchsize=1000, shuffle=true)

opt = Adam(1e-4)
opt_state = Flux.setup(opt, deeponet)

losses = []
@showprogress for epoch in 1:1_000
    for data in dataloader
        # Unpack batch of data, and move to GPU:
        u, y, s = data
        loss, grads = Flux.withgradient(deeponet) do m
            # Evaluate deeponet and loss inside gradient context:
            s_hat = m(u, y)
            Flux.mse(s_hat, s)
        end
        Flux.update!(opt_state, deeponet, grads[1])
        push!(losses, loss)  # logging, outside gradient context
    end
end

valid_U = transpose(np.load("C:/admin/content/j_/0_recent/1518_딥오넷구현J/valid_U.npy")) |> gpu
valid_Y = transpose(np.load("C:/admin/content/j_/0_recent/1518_딥오넷구현J/valid_Y.npy")) |> gpu
valid_S = transpose(np.load("C:/admin/content/j_/0_recent/1518_딥오넷구현J/valid_S.npy")) |> gpu

using Plots
plot(losses, yscale=:log10)
# begin
plot(deeponet(inputs_U[:, 1:100], inputs_Y[:, 1:100])|>vec|>cpu)
plot!(target_S[:,1:100]|>vec|>cpu)

begin
    i=3
    p = plot(inputs_y, vec(deeponet(valid_U[:, 50(i-1)+1:50i], valid_Y[:, 50(i-1)+1:50i])) |> cpu)
    plot!(p, inputs_y, vec(valid_S[:, 50(i-1)+1:50i])|>cpu)
end

begin
    i=1
    p = plot(inputs_y, vec(deeponet(inputs_U[:, 50(i-1)+1:50i], inputs_Y[:, 50(i-1)+1:50i])) |> cpu)
    plot!(p, inputs_y, vec(target_S[:, 50(i-1)+1:50i])|>cpu)
end


branch2 = generate_mlp(branch_layers)
trunk2 = generate_mlp(trunk_layers)
bias2 = randn(Float32, 1)

deeponet2 = DeepONet(branch2, trunk2, bias2) |> gpu

opt2 = AdaBelief(1e-4)
opt_state2 = Flux.setup(opt2, deeponet2)

losses2 = []
@showprogress for epoch in 1:1_000
    for data in dataloader
        # Unpack batch of data, and move to GPU:
        u, y, s = data
        loss, grads = Flux.withgradient(deeponet2) do m
            # Evaluate deeponet and loss inside gradient context:
            s_hat = m(u, y)
            Flux.mse(s_hat, s)
        end
        Flux.update!(opt_state2, deeponet2, grads[1])
        push!(losses2, loss)  # logging, outside gradient context
    end
end

begin
    i=3
    p = plot(inputs_y, vec(deeponet2(valid_U[:, 50(i-1)+1:50i], valid_Y[:, 50(i-1)+1:50i])) |> cpu)
    plot!(p, inputs_y, vec(valid_S[:, 50(i-1)+1:50i])|>cpu)
end
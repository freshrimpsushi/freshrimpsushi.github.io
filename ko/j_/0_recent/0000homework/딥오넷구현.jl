using Distributions
using LinearAlgebra
using Plots

# 1. 공분산 함수 정의 (예: RBF 커널)
function rbf_kernel(x, y; length_scale=1.0, sigma=1.0)
    dist_sq = sum((x .- y').^2, dims=3)
    return sigma^2 .* exp.(-dist_sq ./ (2 * length_scale^2))
end

# 2. 2D 격자 생성
grid_size = 50
x = LinRange(0, 1, grid_size)
y = LinRange(0, 1, grid_size)
X = collect(Iterators.product(x, y))
points = hcat([p[1] for p in X], [p[2] for p in X])

# 3. 공분산 행렬 계산
cov_matrix = rbf_kernel(points, points'; length_scale=0.2, sigma=1.0)

# 4. 가우시안 랜덤 필드 샘플 생성
mean = zeros(size(points, 1))  # 평균은 0으로 설정
samples = rand(MvNormal(mean, cov_matrix))
field = reshape(samples, grid_size, grid_size)

# 5. 결과 시각화
heatmap(x, y, field, color=:viridis, xlabel="X", ylabel="Y", title="Gaussian Random Field Sample")

using Flux, PyCall, ProgressMeter
using CUDA
CUDA.functional()

np = pyimport("numpy")

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
m = 100     # number of sensors

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
sensors = 2M*rand(m) .- M
sensors = sort(sensors)

Num_Ti  = 15 # number of Chebyshev polynomials T_i

inputs_U = transpose(np.load("C:/admin/content/j_/0_recent/1518_딥오넷구현J/inputs_U.npy")) |> gpu
inputs_Y = transpose(np.load("C:/admin/content/j_/0_recent/1518_딥오넷구현J/inputs_Y.npy")) |> gpu
target_S = transpose(np.load("C:/admin/content/j_/0_recent/1518_딥오넷구현J/target_S.npy")) |> gpu

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

#rbf 커널
k(x1, x2, ℓ) = exp(-abs2(x1 - x2)/(2*ℓ^2))
x = LinRange(-1, 1, 100)
Σ = [k(x[i],x[j], 0.2) for i ∈ 1:100, j ∈ 1:100]
ϵ = 1e-6
Σ += ϵ*I

dist = MvNormal(zeros(100), Σ)
xx = rand(dist)
plot(x, xx)

using DifferentialEquations

# Parameters
D = 0.01  # Diffusion coefficient
k_ = 0.01  # Reaction rate
L = 1.0   # Length of the domain
Nx = 100  # Number of spatial points
x = LinRange(-L, L, Nx)  # Spatial grid
dx = x[2] - x[1]        # Grid spacing

u = rand(dist)
plot(x, u)
# Initial condition (zero everywhere)
s0 = zeros(Nx)

# Define the PDE as a system of ODEs
function pde_system!(ds, s, p, t)
    D, k_, u, dx = p
    Nx = length(s)
    ds .= 0  # Reset derivative

    # Compute the second spatial derivative using finite differences
    for i in 2:(Nx-1)
        ds[i] = D * (s[i-1] - 2s[i] + s[i+1]) / dx^2 + k_ * s[i]^2 + u[i]
    end

    # Apply boundary conditions (zero at both ends)
    ds[1] = 0.0
    ds[Nx] = 0.0
end

# Time span
tspan = (0.0, 1.0)

# Parameters for the system
params = (D, k_, u, dx)

# Solve the PDE
prob = ODEProblem(pde_system!, s0, tspan, params)
sol = solve(prob, Tsit5())

# Plot the solution
using Plots
heatmap(x, sol.t, hcat(sol.u...)', xlabel="x", ylabel="t", colorbar_title="s(x,t)")



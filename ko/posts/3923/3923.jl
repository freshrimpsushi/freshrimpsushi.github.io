using Plots
using LinearAlgebra
using Random

Random.seed!(3923)

σ, ℓ, α = 1.0, 1.0, 0.5

rbf(x, y) = σ^2 * exp(-(x - y)^2 / (2ℓ^2))
matern32(x, y) = σ^2 * (1 + √3 * abs(x - y) / ℓ) * exp(-√3 * abs(x - y) / ℓ)
expo(x, y) = σ^2 * exp(-abs(x - y) / ℓ)
linear(x, y) = 0.5^2 + 0.5^2 * x * y
rq(x, y) = σ^2 * (1 + (x - y)^2 / (2α * ℓ^2))^(-α)
white(x, y) = σ^2 * (x == y)

kernels = [rbf, matern32, expo, linear, rq, white]
titles = ["RBF", "Matérn (ν = 3/2)", "Exponential", "Linear", "Rational quadratic", "White noise"]

x = range(-5, 5, length=400)
n = length(x)

# 평균이 0이고 공분산 행렬이 K인 다변량 정규분포에서 함수 5개를 샘플링
function sample_gp(k; m=5)
    K = [k(xᵢ, xⱼ) for xᵢ in x, xⱼ in x]
    L = cholesky(Symmetric(K + 1e-8 * I)).L
    return L * randn(n, m)
end

ps = []
for (k, t) in zip(kernels, titles)
    F = sample_gp(k)
    lw = k === white ? 0.6 : 1.5
    p = plot(x, F, lw=lw, label="", title=t, titlefontsize=11,
        xlims=(-5, 5), ylims=(-3.5, 3.5), framestyle=:box, grid=false, tickfontsize=8)
    push!(ps, p)
end

plot(ps..., layout=(2, 3), size=(1000, 560), dpi=300, margin=3Plots.mm, plot_title=" ", plot_titlevspan=0.03)
savefig(joinpath(@__DIR__, "3923_1.png"))

# 샘플링 절의 예시: [0, 1]에서 균등하게 뽑은 100개의 점, m(x) = 0, k(x, x′) = exp(-r²)
Random.seed!(3923)
N = 100
xs = range(0, 1, length=N)
K = [exp(-(xᵢ - xⱼ)^2) for xᵢ in xs, xⱼ in xs]
L = cholesky(Symmetric(K + 1e-8 * I)).L
F = L * randn(N, 10)    # 10번 샘플링

plot(xs, F, lw=1.5, marker=:circle, ms=1.5, msw=0, label="", xlabel="x", ylabel="f(x)",
    xlims=(0, 1), framestyle=:box, grid=false, size=(700, 400), dpi=300, margin=3Plots.mm)
savefig(joinpath(@__DIR__, "3923_2.png"))

using Plots
using Random

# 원형 평균(circular mean) 계산: 각도 벡터의 평균 방향
circular_mean(θ) = atan(sum(sin.(θ)), sum(cos.(θ)))

# 단위원 위에 데이터(파란 점)와 원형 평균(빨간 점)을 그리는 함수
function plot_circular(center_deg; n=10, spread_deg=20.0, seed=0, title="")
    Random.seed!(seed)
    # center_deg 근처에 데이터 각도 생성 (정규분포)
    θ = deg2rad(center_deg) .+ deg2rad(spread_deg) .* randn(n)
    μ = circular_mean(θ)

    # 단위원
    t = range(0, 2π; length=400)
    plt = plot(cos.(t), sin.(t);
        color=:gray, lw=1.5, label="", aspect_ratio=:equal,
        xlims=(-1.4, 1.4), ylims=(-1.4, 1.4),
        title=title, framestyle=:box, legend=:topright)

    # 데이터 점 (파란색)
    scatter!(plt, cos.(θ), sin.(θ);
        color=:blue, markersize=6, markerstrokewidth=0, label="data")

    # 원형 평균 (빨간색)
    scatter!(plt, [cos(μ)], [sin(μ)];
        color=:red, markersize=9, markerstrokewidth=0, label="circular mean")

    return plt
end

# 0도 근처 / 90도 근처 두 장 생성
p1 = plot_circular(0.0;  seed=1, title="data around 0°")
p2 = plot_circular(90.0; seed=2, title="data around 90°")

# (1,2) layout 최종 그림, dpi=300
final = plot(p1, p2; layout=(1, 2), size=(1000, 500), dpi=300)
savefig(final, "circular_mean.png")
println("Saved circular_mean.png")

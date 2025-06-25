################################################################################
# 패리티 플롯 예제 (Julia + Plots.jl)           
################################################################################
using Random, Statistics
using Plots               # Pkg.add("Plots")  로 미리 설치하세요

# ─────────────────────────────────────────────
# 1. 샘플 데이터 생성
# ─────────────────────────────────────────────
Random.seed!(42)          # 재현 가능성을 위해 시드 고정
n = 100
y_true = range(0, 10, length=n)           # 참값 (선형 증가)

# (1) 예측이 잘 맞는 경우: δ ~ N(0, 0.2)
y_pred_good = y_true .+ 0.2 .* randn(n)

# (2) 예측이 안 맞는 경우: 편향 + 큰 잡음
bias = 3.0
y_pred_bad  = y_true .* 1.3 .+ bias .+ 1.5 .* randn(n)

# ─────────────────────────────────────────────
# 2. 패리티 플롯 함수 정의
# ─────────────────────────────────────────────
function parityplot(y_true1, y_pred1, y_true2, y_pred2)
    p1 = scatter(
        y_true1, y_pred1,
        xlabel="True value",
        ylabel="Predicted value",
        label="",
        markerstrokecolor=:black,
        markersize=4,
        legend=:topleft,
        ratio=:equal,          # 축 비율 1:1
        grid=false, dpi=300,
        size = (200,200), left_margin   = 20Plots.px, xlims=(-1,11), ylims=(-1,11)
    )
    # y = x 기준선
    plot!(p1, -100:100, -100:100, lw=2, color=:black, label="y = x")

    p2 = scatter(
        y_true2, y_pred2,
        xlabel="True value",
        ylabel="Predicted value",
        label="",
        markerstrokecolor=:black,
        markersize=4,
        legend=:topleft,
        ratio=:equal,          # 축 비율 1:1
        grid=false, dpi=300,
        size = (200,350),
    )
    # y = x 기준선
    plot!(p2, -100:100, -100:100, lw=2, color=:black, label="y = x", size=(728,350),
        ylims=(-2,22), xlims=(-2,22),
        bottom_margin = 10Plots.px, dpi=300
        )

    plot(p1, p2)
end

# ─────────────────────────────────────────────
# 3. 플롯 그리기
# ─────────────────────────────────────────────
plt = parityplot(y_true, y_pred_good, y_true, y_pred_bad)
cd = @__DIR__
savefig(joinpath(cd, "1053_1.png"))

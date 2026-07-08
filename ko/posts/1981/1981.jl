@time using LaTeXStrings
@time using Plots

cd(@__DIR__)

# ─────────────────────────────────────────────────────────────
# 1981_1.png : 깊이에 따른 기울기의 지수적 소실/폭주
#   층을 하나 지날 때마다 야코비 노름 r 이 거듭 곱해진다고 보면
#   기울기의 크기는 대략 r^N 으로 변한다.
# ─────────────────────────────────────────────────────────────

N = 0:30
rs = [0.7, 0.9, 1.0, 1.1]
colors = [:royalblue, :seagreen, :black, :tomato]
labels = [L"r=0.7", L"r=0.9", L"r=1.0", L"r=1.1"]

plot(size=(500, 350), dpi=300, yscale=:log10,
     xlabel=L"\mathrm{depth}\ N", ylabel=L"\|\partial \mathcal{L}/\partial h^{(0)}\| \sim r^N",
     legend=:left, framestyle=:box)
for (r, c, lab) in zip(rs, colors, labels)
    plot!(N, r .^ N, lw=2, color=c, label=lab, marker=:circle, ms=3)
end
title!(L"\mathrm{Vanishing\ /\ Exploding\ Gradient}")
savefig("1981_1.png")

# ─────────────────────────────────────────────────────────────
# 1981_2.png : 시그모이드의 포화 — 미분이 최대 1/4 을 넘지 못한다.
# ─────────────────────────────────────────────────────────────

σ(x)  = 1 / (1 + exp(-x))
dσ(x) = σ(x) * (1 - σ(x))

x = -10:0.05:10

plot(size=(500, 350), dpi=300, xlabel=L"x", legend=:topleft, framestyle=:box)
plot!(x, σ.(x),  lw=2, ls=:solid, color=:royalblue, label=L"\sigma")
plot!(x, dσ.(x), lw=2, ls=:dash,  color=:royalblue, label=L"\sigma'")
hline!([0.25], ls=:dot, color=:gray, label=L"1/4")
title!(L"\mathrm{Sigmoid\ Saturation}")
savefig("1981_2.png")

# ─────────────────────────────────────────────────────────────
# 1981_3.png : 활성화함수와 그 도함수 비교 (1행 2열)
#   좌: 시그모이드 vs 하이퍼볼릭탄젠트, 우: 시그모이드 vs ReLU
#   함수 = 실선, 도함수 = 점선, 함수 종류별로 색을 다르게.
# ─────────────────────────────────────────────────────────────

sig(x)  = 1 / (1 + exp(-x))
dsig(x) = sig(x) * (1 - sig(x))

tanh_(x)  = tanh(x)
dtanh_(x) = 1 - tanh(x)^2

relu(x)  = max(0.0, x)
drelu(x) = x > 0 ? 1.0 : 0.0

x = -5:0.01:5

# 좌: 시그모이드 vs tanh
p1 = plot(xlabel=L"x", legend=:topleft, framestyle=:box, ylims=(-1.2, 1.5),
          legendfontsize=11, title=L"\mathrm{sigmoid}\ \mathrm{vs}\ \tanh")
plot!(p1, x, sig.(x),    lw=2, ls=:solid, color=:royalblue, label=L"\sigma")
plot!(p1, x, tanh_.(x),  lw=2, ls=:solid, color=:tomato,    label=L"\tanh")
plot!(p1, x, dsig.(x),   lw=2, ls=:dash,  color=:royalblue, label=L"\sigma'")
plot!(p1, x, dtanh_.(x), lw=2, ls=:dash,  color=:tomato,    label=L"\tanh'")

# 우: 시그모이드 vs ReLU
p2 = plot(xlabel=L"x", legend=:topleft, framestyle=:box, ylims=(-1.2, 1.5),
          legendfontsize=11, title=L"\mathrm{sigmoid}\ \mathrm{vs}\ \mathrm{ReLU}")
plot!(p2, x, sig.(x),   lw=2, ls=:solid, color=:royalblue, label=L"\sigma")
plot!(p2, x, relu.(x),  lw=2, ls=:solid, color=:seagreen,  label=L"\mathrm{ReLU}")
plot!(p2, x, dsig.(x),  lw=2, ls=:dash,  color=:royalblue, label=L"\sigma'")
plot!(p2, x, drelu.(x), lw=2, ls=:dash,  color=:seagreen,  label=L"\mathrm{ReLU}'")

plot(p1, p2, layout=(1, 2), size=(900, 380), dpi=300)
savefig("1981_3.png")

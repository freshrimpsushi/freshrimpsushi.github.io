using Plots
using LaTeXStrings
using LinearAlgebra

# GR 백엔드는 기본 글꼴에 한글이 없다. GR 글꼴 폴더를 복사한 뒤 나눔고딕을 얹어 GKS_FONTPATH 로 지정한다.
begin
    fontdir = joinpath(mktempdir(), "FONTS")
    cp(joinpath(Plots.GR.GRPreferences.grdir[], "fonts"), fontdir)
    for f in ("NanumGothic.ttf", "NanumGothicBold.ttf")
        src = joinpath("C:/Windows/Fonts", f)
        isfile(src) && cp(src, joinpath(fontdir, f))
    end
    ENV["GKS_FONTPATH"] = dirname(fontdir)
end
kfont(size, color) = font(size, "NanumGothic", color)

cross3(a, b) = [a[2]b[3] - a[3]b[2], a[3]b[1] - a[1]b[3], a[1]b[2] - a[2]b[1]]

arrow!(p, from, vec; kw...) = plot!(p, [from[1], from[1] + vec[1]], [from[2], from[2] + vec[2]];
                                    arrow=(:closed, 0.6), lw=2.5, label="", kw...)

# ---------------------------------------------------------------------------
# 그림 2 (5001_2.png). 고정 좌표계 Oxyz 와, 공통 원점을 갖고 축 n 을 중심으로 각속도 ω = ωn 으로
#        회전하는 좌표계 Ox'y'z' (Fowles & Cassiday, Figure 5.2.1 에 대응)
# ---------------------------------------------------------------------------

# 3차원 → 2차원 사영 (x축은 관찰자 쪽 왼쪽 아래, y축은 오른쪽, z축은 위)
proj(v) = [v[2] - 0.5v[1], v[3] - 0.35v[1]]

# 회전축 n 과, n 을 중심으로 α 만큼 돌린 회전 행렬 (로드리게스 공식)
n = normalize([-0.30, 0.55, 0.80])
α = deg2rad(55)
K = [0 -n[3] n[2]; n[3] 0 -n[1]; -n[2] n[1] 0]
R = I + sin(α) * K + (1 - cos(α)) * K^2

e = [[1.0, 0, 0], [0, 1.0, 0], [0, 0, 1.0]]   # i, j, k
e′ = [R * v for v in e]                        # i', j', k'

line3!(p, a, b; kw...) = plot!(p, [proj(a)[1], proj(b)[1]], [proj(a)[2], proj(b)[2]]; label="", kw...)
arrow3!(p, from, vec; kw...) = arrow!(p, proj(from), proj(from .+ vec) .- proj(from); kw...)

Lx, Ly, Lz = 1.1, 1.85, 1.25       # 고정 좌표계 축 길이
Lx′, Ly′, Lz′ = 0.8, 1.85, 1.25    # 회전 좌표계 축 길이 (x' 축은 짧게)
ℓ = 0.5                           # 기저벡터 화살표 길이
c = 1.0 * n; ρ = 0.15             # 회전 방향 원호의 중심, 반지름
W, H = 720, 500                   # 그림 크기 (픽셀)

# 그림에 들어가는 점들의 범위로 표시 영역을 정해 여백을 최소화한다.
ext = vcat([proj(L * v) for (L, v) in zip((Lx, Ly, Lz), e)],
           [proj(L * v) for (L, v) in zip((Lx′, Ly′, Lz′), e′)],
           [proj(1.6 * n) .+ [0.10, 0.10],          # ω 라벨
            proj(c) .+ [0.22 + 0.72, 0.0],           # "axis of rotation" 오른쪽 끝
            [-0.10 - 0.42, proj(Lz * e[3])[2] + 0.04],  # "고정좌표계" 왼쪽 끝
            proj(Lz′ * e′[3]) .+ [0.0, 0.26],         # "회전좌표계" 위쪽
            proj(-0.35 * n), proj(-0.3 * e[1])])
pad = 0.04
xmin, xmax = minimum(q[1] for q in ext) - pad, maximum(q[1] for q in ext) + pad
ymin, ymax = minimum(q[2] for q in ext) - pad - 0.05, maximum(q[2] for q in ext) + pad
# 가로세로비를 캔버스(W:H)에 맞춰 부족한 쪽만 늘린다.
if (xmax - xmin) / (ymax - ymin) < W / H
    d = (ymax - ymin) * W / H - (xmax - xmin); xmin -= d / 2; xmax += d / 2
else
    d = (xmax - xmin) * H / W - (ymax - ymin); ymin -= d / 2; ymax += d / 2
end

p1 = plot(dpi=300, aspect_ratio=:equal, framestyle=:none, size=(W, H), legend=false,
          xlims=(xmin, xmax), ylims=(ymin, ymax), margin=0Plots.mm)

# 고정 좌표계 축 (검정, 가는 선)과 기저벡터 i, j, k
for (v, L, lab, off) in zip(e, (Lx, Ly, Lz), [L"x", L"y", L"z"], [(-0.03, -0.05), (0.05, 0.0), (0.0, 0.05)])
    line3!(p1, -0.3 * v, L * v, lc=:black, lw=1)
    q = proj(L * v)
    annotate!(p1, q[1] + off[1], q[2] + off[2], text(lab, :black, 14))
end
for (v, lab, off) in zip(e, [L"\mathbf{i}", L"\mathbf{j}", L"\mathbf{k}"], [(-0.07, -0.03), (0.0, -0.08), (-0.06, 0.0)])
    arrow3!(p1, zeros(3), ℓ * v, lc=:black, lw=2.5)
    q = proj(ℓ * v)
    annotate!(p1, q[1] + off[1], q[2] + off[2], text(lab, :black, 14))
end
annotate!(p1, -0.10, proj(Lz * e[3])[2] + 0.04, text("고정좌표계", kfont(12, :gray30), :right))

# 회전 좌표계 축 (파랑, 점선)과 기저벡터 i', j', k'
for (v, L, lab, off) in zip(e′, (Lx′, Ly′, Lz′), [L"x'", L"y'", L"z'"], [(-0.03, -0.05), (0.05, 0.0), (0.0, 0.05)])
    line3!(p1, -0.3 * v, L * v, lc=:royalblue, lw=1, ls=:dash)
    q = proj(L * v)
    annotate!(p1, q[1] + off[1], q[2] + off[2], text(lab, :royalblue, 14))
end
qz = proj(Lz′ * e′[3]); annotate!(p1, qz[1] + 0.02, qz[2] + 0.17, text("회전좌표계", kfont(12, :royalblue)))
for (v, lab, off) in zip(e′, [L"\mathbf{i}'", L"\mathbf{j}'", L"\mathbf{k}'"], [(-0.08, 0.0), (0.0, 0.08), (0.08, 0.0)])
    arrow3!(p1, zeros(3), ℓ * v, lc=:royalblue, lw=2.5)
    q = proj(ℓ * v)
    annotate!(p1, q[1] + off[1], q[2] + off[2], text(lab, :royalblue, 14))
end

# 회전축과 각속도 벡터 ω = ωn
line3!(p1, -0.35 * n, 1.55 * n, lc=:tomato, lw=1.2)
arrow3!(p1, zeros(3), ℓ * n, lc=:tomato, lw=2.5)
qn = proj(ℓ * n); annotate!(p1, qn[1] + 0.07, qn[2] - 0.03, text(L"\mathbf{n}", :tomato, 14))
arrow3!(p1, 1.15 * n, 0.45 * n, lc=:tomato, lw=2.5)
qω = proj(1.6 * n); annotate!(p1, qω[1] + 0.05, qω[2] + 0.05, text(L"\omega", :tomato, 15))

# 회전 방향 표시: 축에 수직한 작은 원호 (오른손 규칙)
u1 = normalize(cross3(n, [0, 0, 1.0])); u2 = cross3(n, u1)
φ = range(0.15π, 1.75π, length=120)
ring = [proj(c .+ ρ * (cos(t) * u1 .+ sin(t) * u2)) for t in φ]
plot!(p1, [q[1] for q in ring], [q[2] for q in ring], lc=:tomato, lw=1.5, arrow=(:closed, 0.5), label="")
annotate!(p1, proj(c)[1] + 0.22, proj(c)[2] - 0.02, text("axis of rotation", :gray30, 11, :left))

# 원점
scatter!(p1, [0.0], [0.0], mc=:black, ms=4, label="")
annotate!(p1, 0.08, -0.05, text(L"O", :black, 14, :left, :top))

savefig(p1, joinpath(@__DIR__, "5001_2.png"))

# ---------------------------------------------------------------------------
# 그림 1 (5001_1.png). 위에서 내려다본 회전 좌표계(각속도 ω는 지면에서 나오는 방향, 반시계 회전).
#        위치 r', 속도 v'인 입자에 작용하는 코리올리 힘 -2mω×v' 과 원심력 -mω×(ω×r').
# ---------------------------------------------------------------------------

m = 1.0
ω = [0.0, 0.0, 1.0]
r = [0.50, 0.35, 0.0]
v = [0.22, 0.42, 0.0]

F_cor = -2m * cross3(ω, v)          # v' 을 시계 방향으로 90° 돌린 방향
F_cf  = -m * cross3(ω, cross3(ω, r)) # r' 방향(바깥)

θ = range(0, 2π, length=400)
p2 = plot(cos.(θ), sin.(θ), lc=:gray60, lw=1.5, label="", dpi=300,
          aspect_ratio=:equal, framestyle=:none, size=(820, 560),
          xlims=(-1.3, 2.25), ylims=(-1.15, 1.15), legend=false)

# 회전 방향 (반시계) 화살표
φ = range(0.62π, 0.88π, length=100)
plot!(p2, 1.08cos.(φ), 1.08sin.(φ), lc=:gray40, lw=2, arrow=(:closed, 0.5), label="")
annotate!(p2, 1.15cos(0.75π), 1.15sin(0.75π), text(L"\omega", :gray30, 15, :right, :bottom))

# 회전축(원점). ω 는 지면에서 나오는 방향 ⊙
scatter!(p2, [0.0], [0.0], mc=:white, msc=:black, ms=9, msw=1.5, label="")
scatter!(p2, [0.0], [0.0], mc=:black, ms=3, label="")
annotate!(p2, -0.07, -0.05, text(L"O", :black, 14, :right, :top))

# 위치 벡터 r'
arrow!(p2, [0.0, 0.0], r, lc=:black, lw=2)
annotate!(p2, 0.27, 0.13, text(L"\mathbf{r}'", :black, 15, :right, :bottom))

# 입자
scatter!(p2, [r[1]], [r[2]], mc=:black, ms=6, label="")

# 속도 v'
arrow!(p2, r, v, lc=:royalblue)
annotate!(p2, r[1] + v[1] - 0.03, r[2] + v[2] + 0.02, text(L"\mathbf{v}'", :royalblue, 15, :right, :bottom))

# 코리올리 힘 -2mω×v'
s = 0.5
arrow!(p2, r, s * F_cor, lc=:tomato)
annotate!(p2, r[1] + s * F_cor[1] + 0.04, r[2] + s * F_cor[2] - 0.02,
          text(L"-2m\,\omega\times\mathbf{v}'", :tomato, 14, :left, :top))

# 원심력 -mω×(ω×r')
t = 0.7
arrow!(p2, r, t * F_cf, lc=:seagreen)
annotate!(p2, r[1] + t * F_cf[1] + 0.04, r[2] + t * F_cf[2] + 0.01,
          text(L"-m\,\omega\times(\omega\times\mathbf{r}')", :seagreen, 14, :left, :bottom))

# 직각 표시 (v' ⊥ 코리올리 힘)
u_v = v ./ sqrt(sum(v .^ 2)); u_c = F_cor ./ sqrt(sum(F_cor .^ 2)); d = 0.06
sq = [r .+ d * u_v, r .+ d * (u_v .+ u_c), r .+ d * u_c]
plot!(p2, [q[1] for q in sq], [q[2] for q in sq], lc=:gray50, lw=1, label="")

savefig(p2, joinpath(@__DIR__, "5001_1.png"))

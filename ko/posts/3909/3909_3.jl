using Plots

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

# ---------------------------------------------------------------------------
# 그림 3 (3909_3.gif). 반시계 방향으로 도는 반지름 1인 원판 위에서 (0, -0.8)에 있는 사람이
#        (0, 0.8)에 있는 사람을 향해 공을 던진다. 관성계에서 공은 직선으로 날아가지만,
#        원판과 함께 도는 관찰자에게는 진행 방향의 오른쪽으로 휘어 보인다.
# ---------------------------------------------------------------------------

rot(θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)]

r0 = [0.0, -0.8]       # 던지는 사람(원판에 고정)
rT = [0.0, 0.8]        # 받는 사람(원판에 고정)
T = 1.0                # 공이 y = 0.8에 닿는 시간
v = (rT - r0) / T      # 관성계에서 공의 속도 (원판의 회전 속도는 물려받지 않는다고 가정)
ω = (π / 2) / T        # 공이 나는 동안 원판이 90° 돈다

ball(t) = r0 + v * t                  # 관성계에서 본 공의 위치
ball′(t) = rot(-ω * t) * ball(t)      # 회전 좌표계에서 본 공의 위치

nfly, nhold = 60, 25                  # 비행 프레임, 끝에서 멈춰 있는 프레임
ts = vcat(range(0, T, length=nfly), fill(T, nhold))

θc = range(0, 2π, length=200)
spokes = [rot(k * π / 4) * [1.0, 0.0] for k in 0:3]   # 원판의 회전을 보여주는 지름 4개

function disc!(p, φ, showω)
    plot!(p, cos.(θc), sin.(θc), seriestype=:shape, fc=:gray95, lc=:gray50, lw=1.5, label="")
    for s in spokes
        a = rot(φ) * s
        plot!(p, [-a[1], a[1]], [-a[2], a[2]], lc=:gray80, lw=1, label="")
    end
    showω || return p
    # 회전 방향 화살표
    ψ = range(0.20π, 0.45π, length=50) .+ φ
    plot!(p, 1.1cos.(ψ), 1.1sin.(ψ), lc=:gray40, lw=1.5, arrow=(:closed, 0.4), label="")
    annotate!(p, 1.2cos(ψ[25]), 1.2sin(ψ[25]), text("ω", kfont(9, :gray30)))
end

function panel(φ, pts, now, title; showω=true)
    p = plot(aspect_ratio=:equal, framestyle=:none, legend=false,
             xlims=(-1.3, 1.3), ylims=(-1.05, 1.3))
    disc!(p, φ, showω)
    a, b = rot(φ) * r0, rot(φ) * rT
    scatter!(p, [a[1]], [a[2]], mc=:royalblue, msc=:white, ms=7, label="")
    scatter!(p, [b[1]], [b[2]], mc=:seagreen, msc=:white, ms=7, label="")
    plot!(p, first.(pts), last.(pts), lc=:tomato, lw=2, label="")
    scatter!(p, [now[1]], [now[2]], mc=:tomato, msc=:black, ms=5, label="")
    annotate!(p, 0.0, 1.27, text(title, kfont(9, :black)))
    return p
end

anim = @animate for (i, t) in enumerate(ts)
    hist = ts[1:i]
    p1 = panel(ω * t, [ball(s) for s in hist], ball(t), "관성계 관찰자")
    p2 = panel(0.0, [ball′(s) for s in hist], ball′(t), "회전좌표계 관찰자"; showω=false)
    plot(p1, p2, layout=(1, 2), size=(600, 280), dpi=300, margin=0Plots.mm)
end

gif(anim, joinpath(@__DIR__, "3909_3.gif"), fps=20)

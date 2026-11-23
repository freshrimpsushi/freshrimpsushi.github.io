using Plots
using LaTeXStrings

fc(R, Rc) = R ≤ Rc ? (cos(π * R / Rc) + 1) / 2 : 0.0
dfc(R, Rc) = R ≤ Rc ? -π / (2Rc) * sin(π * R / Rc) : 0.0

circle(x, y, r; n = 100) = Shape(x .+ r .* cos.(range(0, 2π, length = n)),
                                 y .+ r .* sin.(range(0, 2π, length = n)))

# ---------------------------------------------------------------------------
# 3921_1.png: 왼쪽은 원자 i 에서 본 두 원자 j, k 사이의 각 θ_ijk, 오른쪽은 컷오프 함수 f_c 와 그 도함수
# (3920_1.png, 3920_2.png 를 한 그림으로 합친 것)
# ---------------------------------------------------------------------------
xi, xj, xk = [0.0, 0.0], [2.5, 0.1], [1.9, 1.7]
pa = plot(xlims = (-0.5, 3.3), ylims = (-0.85, 2.35), aspect_ratio = :equal,
          framestyle = :none, legend = false)
for (a, b) in ((xi, xj), (xi, xk))
    plot!(pa, [a[1], b[1]], [a[2], b[2]], c = :black, lw = 1.5)
end
plot!(pa, [xj[1], xk[1]], [xj[2], xk[2]], c = :gray, lw = 1, ls = :dash)
t1, t2 = atan(xj[2], xj[1]), atan(xk[2], xk[1])
arc = range(t1, t2, length = 50)
plot!(pa, 0.9 .* cos.(arc), 0.9 .* sin.(arc), c = RGB(0.75, 0, 0), lw = 1.5)
annotate!(pa, 1.3 * cos((t1 + t2) / 2), 1.3 * sin((t1 + t2) / 2),
          text(L"\theta_{ijk}", 12, RGB(0.75, 0, 0)))
for (x, lab, col) in ((xi, L"i", RGB(0, 0, 0.6)), (xj, L"j", :gray60), (xk, L"k", :gray60))
    plot!(pa, circle(x[1], x[2], 0.3), c = col, lc = :black, lw = 1)
    annotate!(pa, x[1], x[2], text(lab, 12, :white))
end
annotate!(pa, 1.35, -0.25, text(L"R_{ij}", 12))
annotate!(pa, 0.7, 1.1, text(L"R_{ik}", 12))
annotate!(pa, 2.65, 1.0, text(L"R_{jk}", 12, :gray40))

Rc = 6.0
R = range(0, 7 / 6 * Rc, length = 1000)
pb = plot(R, fc.(R, Rc), lw = 2, c = RGB(0, 0, 0.6), label = L"f_{c}(R)",
          xlims = (0, 7 / 6 * Rc), ylims = (-0.3, 1.1),
          xticks = ([0, Rc], [L"0", L"R_{c}"]), yticks = ([0, 0.5, 1], [L"0", L"0.5", L"1"]),
          xlabel = L"R", framestyle = :box, gridalpha = 0.15,
          legend = :topright, legendfontsize = 10, tickfontsize = 7, guidefontsize = 8)
# GR 은 ' 와 ^{\prime} 을 제대로 못 그려 유니코드 프라임(U+2032)을 쓴다
plot!(pb, R, dfc.(R, Rc), lw = 2, ls = :dash, c = RGB(0.75, 0, 0), label = L"f′_{c}(R)")
vline!(pb, [Rc], ls = :dash, c = :gray, lw = 1, label = "")

p = plot(pa, pb, layout = grid(1, 2, widths = [0.4, 0.6]), size = (700, 260),
         margin = 2Plots.mm, dpi = 300)
savefig(p, joinpath(@__DIR__, "3921_1.png"))

# ---------------------------------------------------------------------------
# 3921_2.png: BPNN 의 구조. 원자 i 의 이웃 I_i → 대칭함수 벡터 G_i → 신경망 NN → 원자별 에너지 E_i → 합 E
# 모든 원자가 같은 신경망 NN 을 공유한다
# ---------------------------------------------------------------------------
rect(x, y, w, h) = Shape([x - w / 2, x + w / 2, x + w / 2, x - w / 2],
                         [y - h / 2, y - h / 2, y + h / 2, y + h / 2])
blue, red = RGB(0, 0, 0.6), RGB(0.75, 0, 0)
xI, xG, xNN, xE, xS, xT = 0.0, 2.1, 4.7, 7.3, 9.1, 10.7   # 각 열의 x 좌표
rows = ((3.3, "1"), (2.2, "2"), (0.0, "N"))                 # (y 좌표, 원자 번호)
yS = 1.65

p2 = plot(xlims = (-0.8, 11.4), ylims = (-0.6, 4.6), aspect_ratio = :equal,
          framestyle = :none, legend = false, size = (700, 300), margin = 0Plots.mm, dpi = 300)
arrow!(plt, x1, y1, x2, y2) = plot!(plt, [x1, x2], [y1, y2], c = :black, lw = 1, arrow = true)

# 신경망 NN 의 축소 그림: 층별 노드 수 (3, 4, 4, 1)
function mlp!(plt, x0, y0)
    layers = [[(x0 + dx, y0 + dy) for dy in (n == 1 ? [0.0] : range(-0.33, 0.33, length = n))]
              for (dx, n) in zip((-0.75, -0.25, 0.25, 0.75), (3, 4, 4, 1))]
    for (A, B) in zip(layers[1:end-1], layers[2:end]), a in A, b in B
        plot!(plt, [a[1], b[1]], [a[2], b[2]], c = :gray55, lw = 0.4)
    end
    for L in layers, (x, y) in L
        plot!(plt, circle(x, y, 0.075, n = 30), c = blue, lc = blue, lw = 0.5)
    end
end

for (y, n) in rows
    plot!(p2, circle(xI, y, 0.42), c = :gray90, lc = :black, lw = 1)
    annotate!(p2, xI, y, text(latexstring("\\mathcal{I}_{$(n)}"), 11))
    plot!(p2, rect(xG, y, 1.1, 0.75), c = :white, lc = red, lw = 1.2)
    annotate!(p2, xG, y, text(latexstring("\\mathbf{G}_{$(n)}"), 11, red))
    plot!(p2, rect(xNN, y, 2.1, 0.95), c = :white, lc = blue, lw = 1.2)
    mlp!(p2, xNN, y)
    plot!(p2, rect(xE, y, 1.1, 0.75), c = :white, lc = :black, lw = 1.2)
    annotate!(p2, xE, y, text(latexstring("E_{$(n)}"), 11))
    arrow!(p2, xI + 0.42, y, xG - 0.6, y)
    arrow!(p2, xG + 0.55, y, xNN - 1.1, y)
    arrow!(p2, xNN + 1.05, y, xE - 0.6, y)
    arrow!(p2, xE + 0.55, y, xS - 0.42 * cos(atan(y - yS, xS - xE - 0.55) ) - 0.03,
           yS + 0.45 * (y - yS) / hypot(y - yS, xS - xE - 0.55))
end
for x in (xI, xG, xNN, xE)
    annotate!(p2, x, 1.1, text(L"\vdots", 13))
end
plot!(p2, circle(xS, yS, 0.42), c = :white, lc = :black, lw = 1.2)
annotate!(p2, xS, yS, text(L"\sum", 11))
arrow!(p2, xS + 0.42, yS, xT - 0.45, yS)
annotate!(p2, xT, yS, text(L"E", 14))
for (x, lab) in ((xI, L"\mathcal{I}_{i}"), (xG, L"\mathbf{G}_{i} = \mathbf{G}(\mathcal{I}_{i})"),
                 (xNN, L"\mathrm{NN}"), (xE, L"E_{i} = \mathrm{NN}(\mathbf{G}_{i})"))
    annotate!(p2, x, 4.25, text(lab, 9, :gray30))
end
annotate!(p2, xT - 0.2, yS - 0.9, text(L"E = \sum_{i=1}^{N} E_{i}", 9, :gray30))
savefig(p2, joinpath(@__DIR__, "3921_2.png"))

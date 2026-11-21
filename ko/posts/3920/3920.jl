using Plots
using LaTeXStrings

# 반경 대칭함수 그림의 매개변수는 Behler (2011) FIG. 3 을 따른다
fc(R, Rc) = R ≤ Rc ? (cos(π * R / Rc) + 1) / 2 : 0.0
dfc(R, Rc) = R ≤ Rc ? -π / (2Rc) * sin(π * R / Rc) : 0.0

circle(x, y, r; n = 100) = Shape(x .+ r .* cos.(range(0, 2π, length = n)),
                                 y .+ r .* sin.(range(0, 2π, length = n)))

# ---------------------------------------------------------------------------
# 3920_1.png: 원자 i 에서 본 두 원자 j, k 사이의 각 θ_ijk
# ---------------------------------------------------------------------------
xi, xj, xk = [0.0, 0.0], [3.7, 0.2], [3.9, 1.5]
p1 = plot(xlims = (-1, 5), ylims = (-0.4, 1.9), aspect_ratio = :equal,
          framestyle = :none, legend = false, size = (700, 200), dpi = 300)
for (a, b) in ((xi, xj), (xi, xk))
    plot!(p1, [a[1], b[1]], [a[2], b[2]], c = :black, lw = 1.5)
end
plot!(p1, [xj[1], xk[1]], [xj[2], xk[2]], c = :gray, lw = 1, ls = :dash)
t1, t2 = atan(xj[2], xj[1]), atan(xk[2], xk[1])
arc = range(t1, t2, length = 50)
plot!(p1, 1.4 .* cos.(arc), 1.4 .* sin.(arc), c = RGB(0.75, 0, 0), lw = 1.5)
annotate!(p1, 1.7 * cos((t1 + t2) / 2), 1.6 * sin((t1 + t2) / 2),
          text(L"\theta_{ijk}", 13, RGB(0.75, 0, 0)))
for (x, lab, col) in ((xi, L"i", RGB(0, 0, 0.6)), (xj, L"j", :gray60), (xk, L"k", :gray60))
    plot!(p1, circle(x[1], x[2], 0.3), c = col, lc = :black, lw = 1)
    annotate!(p1, x[1], x[2], text(lab, 13, :white))
end
annotate!(p1, 3.0, -0.15, text(L"R_{ij}", 13))
annotate!(p1, 2.8, 1.35, text(L"R_{ik}", 13))
annotate!(p1, 4.15, 0.85, text(L"R_{jk}", 13, :gray40))
savefig(p1, joinpath(@__DIR__, "3920_1.png"))

# ---------------------------------------------------------------------------
# 3920_2.png: 컷오프 함수 f_c 와 그 도함수 (3919.jl 재사용)
# ---------------------------------------------------------------------------
Rc = 6.0
R = range(0, 7 / 6 * Rc, length = 1000)
p2 = plot(R, fc.(R, Rc), lw = 2, c = RGB(0, 0, 0.6), label = L"f_{c}(R)",
          xlims = (0, 7 / 6 * Rc), ylims = (-0.3, 1.1),
          xticks = ([0, Rc], [L"0", L"R_{c}"]), yticks = ([0, 0.5, 1], [L"0", L"0.5", L"1"]),
          xlabel = L"R", framestyle = :box, gridalpha = 0.15,
          legend = :topright, legendfontsize = 10, tickfontsize = 7, guidefontsize = 8,
          size = (700, 300), margin = 2Plots.mm, dpi = 300)
plot!(p2, R, dfc.(R, Rc), lw = 2, ls = :dash, c = RGB(0.75, 0, 0), label = L"f′_{c}(R)")  # GR 은 ' 와 ^{\prime} 을 제대로 못 그려 유니코드 프라임(U+2032)을 쓴다
vline!(p2, [Rc], ls = :dash, c = :gray, lw = 1, label = "")
savefig(p2, joinpath(@__DIR__, "3920_2.png"))

# ---------------------------------------------------------------------------
# 3920_3.png: 원자 i 와 그 주위의 원자들, 컷오프 반경과 거리 R_ij
# ---------------------------------------------------------------------------
p3 = plot(xlims = (-6.3, 6.3), ylims = (-2.7, 2.7), aspect_ratio = :equal,
          framestyle = :none, legend = false, size = (700, 300), margin = 0Plots.mm, dpi = 300)
plot!(p3, circle(0, 0, 2.6, n = 200), fillalpha = 0.05, c = RGB(0, 0, 0.6),
      lc = :gray, ls = :dash, lw = 1)
plot!(p3, [0, 2.6 * cos(-0.6)], [0, 2.6 * sin(-0.6)], c = :gray, lw = 1, ls = :dot)
annotate!(p3, 1.55 * cos(-0.6) + 0.05, 1.55 * sin(-0.6) - 0.3, text(L"R_{c}", 14, :gray40))
xj3 = [1.7, 0.9]
plot!(p3, [0, xj3[1]], [0, xj3[2]], c = :black, lw = 1.5)
annotate!(p3, 0.7, 0.85, text(L"R_{ij}", 14))
for x in ([-1.4, 1.2], [-0.9, -1.6], [0.6, -1.3], [2.9, 1.9],
          [-4.4, 1.4], [-5.4, -0.9], [-3.4, -2.0], [4.2, -1.5], [5.4, 0.9], [-3.5, 0.2])
    plot!(p3, circle(x[1], x[2], 0.3), c = :gray75, lc = :black, lw = 1)
end
plot!(p3, circle(xj3[1], xj3[2], 0.3), c = :gray60, lc = :black, lw = 1)
annotate!(p3, xj3[1], xj3[2], text(L"j", 14, :white))
plot!(p3, circle(0, 0, 0.3), c = RGB(0, 0, 0.6), lc = :black, lw = 1)
annotate!(p3, 0, 0, text(L"i", 14, :white))
savefig(p3, joinpath(@__DIR__, "3920_3.png"))

# ---------------------------------------------------------------------------
# 3920_4.png: 이웃이 하나뿐인 원자의 G^2. 왼쪽 R_s = 0, 오른쪽 R_s > 0  [FIG. 3(b), (c)]
# ---------------------------------------------------------------------------
Rc2 = 11.3
r = range(0, 14, length = 1000)
common = (xlims = (0, 14), framestyle = :box, gridalpha = 0.15, xlabel = L"R",
          legendfontsize = 9, tickfontsize = 8, guidefontsize = 9, fontfamily = "Computer Modern")
pa = plot(; common..., xlabel = L"R", ylims = (0, 1.02), ylabel = L"G^{2}(R)",
          title = L"G^{2},\ R_{s} = 0", titlefontsize = 14, legend = :topright)
for η in (5.0, 0.4, 0.1, 0.03, 0.01)
    plot!(pa, r, exp.(-η .* r .^ 2) .* fc.(r, Rc2), lw = 1.5,
          label = latexstring("\\eta = $(η)"))
end
pb = plot(; common..., xlabel = L"R", ylims = (0, 1.02), ylabel = L"G^{2}(R)",
          title = L"G^{2},\ R_{s} > 0, \eta=3", titlefontsize = 14, legend = :topright)
for Rs in 2.0:2.0:12.0
    plot!(pb, r, exp.(-3.0 .* (r .- Rs) .^ 2) .* fc.(r, Rc2), lw = 1.5,
          label = latexstring("R_{s} = $(Rs)"))
end
p4 = plot(pa, pb, layout = (1, 2), size = (900, 340), margin = 4Plots.mm, dpi = 300)
savefig(p4, joinpath(@__DIR__, "3920_4.png"))

# ---------------------------------------------------------------------------
# 3920_5.png: 이웃이 하나뿐인 원자의 G^3  [FIG. 3(d)]
# ---------------------------------------------------------------------------
p5 = plot(; common..., ylims = (-1.02, 1.02), ylabel = L"G^{3}(R)", legend = :topright,
          size = (500, 300), margin = 3Plots.mm, dpi = 300)
hline!(p5, [0], c = :gray, lw = 0.8, label = "")
for (n, κ) in enumerate((0.5, 1.0, 1.5, 2.0))
    plot!(p5, r, cos.(κ .* r) .* fc.(r, Rc2), lw = 1.5, c = palette(:default)[n],
          label = latexstring("\\kappa = $(κ)"))
end
savefig(p5, joinpath(@__DIR__, "3920_5.png"))

# ---------------------------------------------------------------------------
# 3920_6.png: 3920_3.png 에 원자 k 를 더해 거리 R_ij, R_ik, R_jk 와 각 θ_ijk 를 표시
# ---------------------------------------------------------------------------
p6 = plot(xlims = (-6.3, 6.3), ylims = (-2.7, 2.7), aspect_ratio = :equal,
          framestyle = :none, legend = false, size = (700, 300), margin = 0Plots.mm, dpi = 300)
plot!(p6, circle(0, 0, 2.6, n = 200), fillalpha = 0.05, c = RGB(0, 0, 0.6),
      lc = :gray, ls = :dash, lw = 1)
plot!(p6, [0, 2.6 * cos(-0.6)], [0, 2.6 * sin(-0.6)], c = :gray, lw = 1, ls = :dot)
annotate!(p6, 1.55 * cos(-0.6) + 0.05, 1.55 * sin(-0.6) - 0.3, text(L"R_{c}", 14, :gray40))
xj6, xk6 = [1.7, 0.9], [-0.2, 1.5]
plot!(p6, [0, xj6[1]], [0, xj6[2]], c = :black, lw = 1.5)
plot!(p6, [0, xk6[1]], [0, xk6[2]], c = :black, lw = 1.5)
plot!(p6, [xj6[1], xk6[1]], [xj6[2], xk6[2]], c = :black, lw = 1.5)
a1, a2 = atan(xj6[2], xj6[1]), atan(xk6[2], xk6[1])
arc6 = range(a1, a2, length = 50)
plot!(p6, 0.45 .* cos.(arc6), 0.45 .* sin.(arc6), c = RGB(0.75, 0, 0), lw = 1.5)
annotate!(p6, 0.72 * cos((a1 + a2) / 2), 0.72 * sin((a1 + a2) / 2), text(L"\theta_{ijk}", 12, RGB(0.75, 0, 0)))
annotate!(p6, 1.1, 0.2, text(L"R_{ij}", 14))
annotate!(p6, -0.5, 0.75, text(L"R_{ik}", 14))
annotate!(p6, 0.8, 1.6, text(L"R_{jk}", 14))
for x in ([-0.9, -1.6], [0.6, -1.3], [2.9, 1.9],
          [-4.4, 1.4], [-5.4, -0.9], [-3.4, -2.0], [4.2, -1.5], [5.4, 0.9], [-3.5, 0.2])
    plot!(p6, circle(x[1], x[2], 0.3), c = :gray75, lc = :black, lw = 1)
end
for (x, lab) in ((xj6, L"j"), (xk6, L"k"))
    plot!(p6, circle(x[1], x[2], 0.3), c = :gray60, lc = :black, lw = 1)
    annotate!(p6, x[1], x[2], text(lab, 14, :white))
end
plot!(p6, circle(0, 0, 0.3), c = RGB(0, 0, 0.6), lc = :black, lw = 1)
annotate!(p6, 0, 0, text(L"i", 14, :white))
savefig(p6, joinpath(@__DIR__, "3920_6.png"))

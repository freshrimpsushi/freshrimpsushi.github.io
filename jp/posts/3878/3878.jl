using Plots, Random, Printf, Statistics, Measures

# 층 정규화 시각자료 후보들
# 데이터 행렬 A: 행 = 배치 안의 데이터 (N개), 열 = 층의 성분/특성 (H개)
# 층 정규화 = 행 방향(데이터 하나의 모든 성분)으로 mu, sigma
# 배치 정규화 = 열 방향(하나의 성분에 대한 배치 전체)으로 mu, sigma

const NB = 5     # 배치 크기 N
const HH = 8     # 성분 수 H

Random.seed!(3878)
A = round.(2 .* randn(NB, HH) .+ 1.5, digits = 2)

nrm(v) = (v .- mean(v)) ./ std(v, corrected = false)
lnorm(M) = reduce(vcat, [nrm(M[r, :])' for r in 1:size(M, 1)])          # 행마다
bnorm(M) = reduce(hcat, [nrm(M[:, c])  for c in 1:size(M, 2)])          # 열마다

const LNC = [RGB(.85, .33, .29), RGB(.93, .60, .22), RGB(.45, .68, .35),
             RGB(.29, .53, .78), RGB(.55, .40, .70)]
const BNC = [RGB(.29, .53, .78), RGB(.93, .60, .22), RGB(.45, .68, .35), RGB(.85, .33, .29),
             RGB(.55, .40, .70), RGB(.35, .70, .72), RGB(.80, .50, .65), RGB(.60, .60, .25)]

"셀을 색으로 채운 스키마틱 격자. group=:row 면 행마다, :col 이면 열마다 색을 달리한다."
function schematic(group, title, note)
    p = plot(xlims = (.5, HH + .5), ylims = (.5, NB + .5), yflip = true,
             aspect_ratio = :equal, framestyle = :box, legend = false,
             title = title * "\n" * note, titlefontsize = 11,
             xlabel = "component  i   (H = $HH)", ylabel = "data in batch",
             xlabelfontsize = 9, ylabelfontsize = 9,
             xticks = 1:HH, yticks = 1:NB, tickfontsize = 8)
    for r in 1:NB, c in 1:HH
        col = group === :row ? LNC[r] : BNC[c]
        plot!(p, Shape([c - .5, c + .5, c + .5, c - .5], [r - .5, r - .5, r + .5, r + .5]),
              c = col, lc = :white, lw = 1.4, fillalpha = .75, label = "")
    end
    p
end

# ── 후보 1: 어느 방향으로 평균을 내는가 (층 정규화 vs 배치 정규화) ─────────
p1 = plot(schematic(:row, "layer normalization",
                    "same color = same mu, sigma   (one datum, all components)"),
          schematic(:col, "batch normalization",
                    "same color = same mu, sigma   (one component, whole batch)"),
          layout = (1, 2), size = (1300, 480), dpi = 300,
          left_margin = 6mm, bottom_margin = 8mm, top_margin = 6mm)
savefig(p1, "3878_1.png")

# ── 후보 2: 성분 프로파일 — 데이터마다 자기 mu, sigma 로 정규화된다 ────────
sel = sortperm([mean(A[r, :]) for r in 1:NB])[[1, 3, 5]]   # 평균이 잘 벌어진 세 데이터
lo, hi = minimum(A[sel, :]), maximum(A[sel, :])
p2a = plot(title = "before:  each datum has its own mu, sigma", titlefontsize = 11,
           xlabel = "component  i", ylabel = "value", xlims = (.5, HH + .5),
           ylims = (lo - .7, hi + 3.2),
           xticks = 1:HH, tickfontsize = 8, framestyle = :box,
           xlabelfontsize = 9, ylabelfontsize = 9, legend = :top, legendfontsize = 8)
for r in sel
    m, s = mean(A[r, :]), std(A[r, :], corrected = false)
    hline!(p2a, [m], c = LNC[r], ls = :dash, lw = 1.4, label = "")
    plot!(p2a, 1:HH, A[r, :], c = LNC[r], lw = 2, m = :circle, ms = 4,
          label = "datum $r:  mu = $(@sprintf("%.2f", m)),  sigma = $(@sprintf("%.2f", s))")
end
Ahat = lnorm(A)
p2b = plot(title = "after:  every datum has mu = 0, sigma = 1", titlefontsize = 11,
           xlabel = "component  i", ylabel = "value", xlims = (.5, HH + .5),
           xticks = 1:HH, tickfontsize = 8, framestyle = :box,
           xlabelfontsize = 9, ylabelfontsize = 9, legend = :top, legendfontsize = 8,
           ylims = (-2.6, 4.4))
hspan!(p2b, [-1, 1], c = :gray, alpha = .12, label = "")
hline!(p2b, [0], c = :gray, ls = :dash, lw = 1.4, label = "")
for r in sel
    plot!(p2b, 1:HH, Ahat[r, :], c = LNC[r], lw = 2, m = :circle, ms = 4,
          label = "datum $r:  mu = 0,  sigma = 1")
end
p2 = plot(p2a, p2b, layout = (1, 2), size = (1250, 560), dpi = 300, margin = 4mm)
savefig(p2, "3878_2.png")

# ── 후보 3: 원래 → 정규화 → 게인/바이어스 3단 히트맵 ──────────────────────
g = [1.4, .6, 1.0, 1.8, .5, 1.2, .8, 1.5]
b = [0., 1., -1., .5, 0., -.5, 1.5, 0.]
Aout = Ahat .* g' .+ b'

function hm(M, title, lim = maximum(abs, M))
    p = heatmap(1:HH, 1:NB, M, c = :RdBu, clims = (-lim, lim), yflip = true,
                title = title, titlefontsize = 10, aspect_ratio = :equal,
                xlabel = "component  i", ylabel = "data in batch",
                xlabelfontsize = 9, ylabelfontsize = 9,
                xticks = 1:HH, yticks = 1:NB, tickfontsize = 8, framestyle = :box)
    for r in 1:NB, c in 1:HH
        annotate!(p, c, r, text(@sprintf("%.1f", M[r, c]), 6, :black))
    end
    plot!(p, xlims = (.5, HH + .5), ylims = (.5, NB + .5), legend = false)
end
p3 = plot(hm(A, "a"),
          hm(Ahat, "(a - mu 1) / sigma"),
          hm(Aout, "g .* (a - mu 1)/sigma + b   =  LN(a)"),
          layout = (1, 3), size = (1650, 400), dpi = 300,
          left_margin = 6mm, bottom_margin = 6mm)
savefig(p3, "3878_3.png")

# ── 후보 4: 같은 데이터, 다른 배치 — LN 은 불변, BN 은 바뀐다 ──────────────
a0 = A[1, :]
B1 = A                                   # 배치 A
B2 = vcat(a0', round.(3 .* randn(NB - 1, HH) .- 2, digits = 2))   # 같은 a0, 다른 동료들
lnA, lnB = lnorm(B1)[1, :], lnorm(B2)[1, :]
bnA, bnB = bnorm(B1)[1, :], bnorm(B2)[1, :]

function pair(y1, y2, title, note)
    p = groupedbar(hcat(y1, y2), bar_position = :dodge, bar_width = .7,
                   c = [RGB(.29, .53, .78) RGB(.93, .60, .22)], lc = :white, lw = .5,
                   label = ["in batch 1" "in batch 2"], legend = :topright,
                   legendfontsize = 8, title = title, titlefontsize = 11,
                   xlabel = "component  i", ylabel = "normalized value",
                   xlabelfontsize = 9, ylabelfontsize = 9,
                   xticks = (1:HH, string.(1:HH)), tickfontsize = 8,
                   framestyle = :box, ylims = (-2.9, 2.9))
    annotate!(p, (HH + 1) / 2, -2.45, text(note, 9, RGB(.25, .25, .25)))
    p
end
using StatsPlots
p4 = plot(pair(lnA, lnB, "layer normalization of the same datum",
               "identical  ->  independent of the batch"),
          pair(bnA, bnB, "batch normalization of the same datum",
               "different  ->  depends on the batch"),
          layout = (1, 2), size = (1300, 520), dpi = 300, margin = 4mm)
savefig(p4, "3878_4.png")

# ── 후보 5: 한 데이터의 성분들을 수직선 위에 (정규화 전/후) ────────────────
r0 = 2
v, w = A[r0, :], Ahat[r0, :]
m0, s0 = mean(v), std(v, corrected = false)
p5 = plot(size = (1200, 400), dpi = 300, legend = false, framestyle = :none,
          xlims = (-12.5, 8.8), ylims = (-.9, 2.25), margin = 5mm)
for (y, x, m, s, lab) in ((1.35, v, m0, s0, "a"), (.15, w, 0., 1., "(a - mu 1) / sigma"))
    plot!(p5, [-7, 8], [y, y], c = :black, lw = 1.1)
    plot!(p5, Shape([m - s, m + s, m + s, m - s], [y - .2, y - .2, y + .2, y + .2]),
          c = RGB(.29, .53, .78), fillalpha = .13, lc = :match)
    plot!(p5, [m, m], [y - .27, y + .27], c = RGB(.85, .33, .29), lw = 2)
    scatter!(p5, x, fill(y, HH), m = :circle, ms = 7, c = RGB(.29, .53, .78),
             msc = :white, msw = 1.2)
    annotate!(p5, -7.4, y, text(lab, 10, :right))
    annotate!(p5, m, y + .42, text("mu = $(@sprintf("%.2f", m))", 8, RGB(.85, .33, .29)))
    annotate!(p5, m + s, y - .42, text("+ sigma", 8, RGB(.29, .53, .78)))
end
for t in -6:2:8
    annotate!(p5, t, -.55, text(string(t), 8, RGB(.4, .4, .4)))
end
annotate!(p5, -2, 2.1, text("one datum: its H components, before and after layer normalization",
          10, RGB(.25, .25, .25)))
savefig(p5, "3878_5.png")

println("saved 3878_1.png ... 3878_5.png")

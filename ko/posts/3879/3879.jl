using Plots, Random, Printf, Measures, LaTeXStrings

# 마스크드 어텐션 시각자료 후보들
# 표기 규약: 행 i = 키의 위치, 열 j = 쿼리의 위치, 인과 마스크는 i > j 를 가린다.
# (열벡터 기준이므로 가시영역이 상삼각이다. 논문의 행벡터 기준 그림과 전치 관계.)

const GRAY = RGB(0.82, 0.82, 0.82)   # 마스킹된 칸
const NN = 6                          # 수열 길이 (n = m)
const DK = 8                          # d_k

Random.seed!(3879)
Q = randn(DK, NN)
K = randn(DK, NN)
S = K' * Q ./ sqrt(DK)                # S[i,j] = k_i' q_j / sqrt(d_k)

causal(m, n) = [i > j for i in 1:m, j in 1:n]   # true = 가린다

function softmax_cols(A)
    P = similar(A)
    for j in axes(A, 2)
        c = A[:, j]
        f = isfinite.(c)
        e = zeros(length(c))
        e[f] = exp.(c[f] .- maximum(c[f]))
        P[:, j] = e ./ sum(e)
    end
    P
end

"마스킹된 칸을 회색 사각형으로 덮는다."
function shade!(p, mask)
    m, n = size(mask)
    for i in 1:m, j in 1:n
        mask[i, j] || continue
        plot!(p, Shape([j - .5, j + .5, j + .5, j - .5], [i - .5, i - .5, i + .5, i + .5]),
              c = GRAY, lc = :white, lw = .8, label = "")
    end
    p
end

"셀 값 텍스트."
function label!(p, A, mask; fmt = x -> @sprintf("%.2f", x), masktext = "")
    m, n = size(A)
    for i in 1:m, j in 1:n
        s = mask[i, j] ? masktext : fmt(A[i, j])
        isempty(s) && continue
        annotate!(p, j, i, text(s, 7, mask[i, j] ? RGB(.35, .35, .35) : :black))
    end
    p
end

function grid(A, mask, title; cmap = :RdBu, clim = nothing, masktext = "",
               fmt = x -> @sprintf("%.2f", x), cbar = true)
    m, n = size(A)
    B = copy(A); B[mask] .= NaN
    kw = clim === nothing ? (;) : (; clims = clim)
    p = heatmap(1:n, 1:m, B; c = cmap, yflip = true, title = title, titlefontsize = 15,
                xlabel = "query  j", ylabel = "key  i", xlabelfontsize = 9, ylabelfontsize = 9,
                xticks = 1:n, yticks = 1:m, tickfontsize = 8, aspect_ratio = :equal,
                framestyle = :box, colorbar = cbar, kw...)
    shade!(p, mask)
    label!(p, A, mask; fmt = fmt, masktext = masktext)
    plot!(p, xlims = (.5, n + .5), ylims = (.5, m + .5), legend = false)
end

M = causal(NN, NN)
Smasked = copy(S); Smasked[M] .= -Inf
P = softmax_cols(Smasked)
Pfull = softmax_cols(S)

# ── 후보 1: 스코어 → 마스킹 → 소프트맥스 3단 ──────────────────────────────
lim = maximum(abs, S)
# 첫 행에 2개, 둘째 행에 1개를 가운데 배치 (셋 다 같은 너비가 되도록 0.5w)
lay1 = @layout [a b
                _ c{0.5w} _]
# GR 의 수식 렌더러는 \text{} 를 지원하지 않는다. \mathrm{} 과 낱말 사이 `\ ` 를 쓴다.
p1 = plot(grid(S, falses(NN, NN),
               L"\mathrm{score} = \mathbf{K}^{\mathsf{T}} \mathbf{Q} / \sqrt{d_{k}}";
               clim = (-lim, lim)),
          grid(S, M, L"\mathrm{Masked\ score} = \mathrm{score} + \mathbf{M}";
               clim = (-lim, lim), masktext = "-inf"),
          grid(P, M, L"\mathrm{Softmax}(\mathrm{score} + \mathbf{M})";
               cmap = :viridis, clim = (0, 1), masktext = "0"),
          layout = lay1, size = (1000, 700), dpi = 300,
          left_margin = 7mm, bottom_margin = 4mm, top_margin = 3mm, right_margin = 2mm)
savefig(p1, "3879_1.png")

# ── 후보 2: 마스크 행렬 M 단독 ─────────────────────────────────────────────
Z = Float64.(.!M)
p2 = heatmap(1:NN, 1:NN, Z, c = cgrad([GRAY, RGB(.78, .87, .96)]), yflip = true,
             xlabel = "query  j", ylabel = "key  i", xticks = 1:NN, yticks = 1:NN,
             aspect_ratio = :equal, framestyle = :box, colorbar = false,
             title = "causal mask  M", titlefontsize = 11,
             size = (560, 520), dpi = 300, margin = 4mm)
vline!(p2, (1:NN-1) .+ .5, c = :white, lw = 1.2, label = "")
hline!(p2, (1:NN-1) .+ .5, c = :white, lw = 1.2, label = "")
for i in 1:NN, j in 1:NN
    annotate!(p2, j, i, text(M[i, j] ? "-inf" : "0", 9,
              M[i, j] ? RGB(.35, .35, .35) : :black))
end
plot!(p2, xlims = (.5, NN + .5), ylims = (.5, NN + .5), legend = false)
savefig(p2, "3879_2.png")

# ── 후보 3: 열별 어텐션 분포 (각 열의 합 = 1) ──────────────────────────────
function col(j)
    p = plot(title = "query j = $j", titlefontsize = 10, legend = false,
             xlims = (.5, NN + .5), ylims = (0, 1), xlabel = "key  i", ylabel = "attention",
             xticks = 1:NN, yticks = 0:.25:1, tickfontsize = 8,
             xlabelfontsize = 9, ylabelfontsize = 9, framestyle = :box)
    j < NN && vspan!(p, [j + .5, NN + .5], c = GRAY, lc = :match, alpha = .55, label = "")
    bar!(p, 1:NN, P[:, j], c = :steelblue, lc = :white, lw = .5, label = "")
    j < NN && annotate!(p, (j + NN + 1) / 2, .72, text("masked", 8, RGB(.4, .4, .4)))
    p
end
p3 = plot(col.(1:NN)..., layout = (2, 3), size = (1250, 660), dpi = 300,
          left_margin = 4mm, bottom_margin = 4mm)
savefig(p3, "3879_3.png")

# ── 후보 4: 마스킹 없음 vs 있음 ────────────────────────────────────────────
p4 = plot(grid(Pfull, falses(NN, NN), "Softmax(score)   (no mask)";
               cmap = :viridis, clim = (0, 1)),
          grid(P, M, "Softmax(score + M)   (causal)";
               cmap = :viridis, clim = (0, 1), masktext = "0"),
          layout = (1, 2), size = (1040, 470), dpi = 300, margin = 4mm)
savefig(p4, "3879_4.png")

# ── 후보 5: 패딩 마스크, 그리고 인과 + 패딩 ────────────────────────────────
PADFROM = 5                                        # 5, 6번 위치는 패딩
pad = [i >= PADFROM for i in 1:NN, j in 1:NN]      # 패딩 키를 가린다
both = M .| pad
Ppad  = softmax_cols(let A = copy(S); A[pad]  .= -Inf; A end)
Pboth = softmax_cols(let A = copy(S); A[both] .= -Inf; A end)
p5 = plot(grid(Ppad,  pad,  "padding mask only";
               cmap = :viridis, clim = (0, 1), masktext = "0"),
          grid(Pboth, both, "causal + padding";
               cmap = :viridis, clim = (0, 1), masktext = "0"),
          layout = (1, 2), size = (1040, 470), dpi = 300, margin = 4mm)
savefig(p5, "3879_5.png")

# ── 후보 6: 열벡터 관례 vs 논문의 행벡터 관례 (전치 관계) ──────────────────
p6 = plot(grid(P, M, "column convention (this blog):  V Softmax(K'Q/sqrt(d_k) + M)";
               cmap = :viridis, clim = (0, 1), masktext = "0"),
          grid(permutedims(P), permutedims(M),
               "row convention (paper):  softmax(QK'/sqrt(d_k) + M) V";
               cmap = :viridis, clim = (0, 1), masktext = "0"),
          layout = (1, 2), size = (1120, 480), dpi = 300, margin = 4mm)
plot!(p6[2], xlabel = "key  i", ylabel = "query  j")
savefig(p6, "3879_6.png")

println("saved 3879_1.png ... 3879_6.png")

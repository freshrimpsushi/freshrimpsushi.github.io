# 3539_1.png: seq2seq 모델 구조도 (인코더 → 컨텍스트 벡터 → 디코더)
using Plots
using LaTeXStrings

rectangle(x, y, w, h) = Shape(x .+ [0, w, w, 0], y .+ [0, 0, h, h])

W, H = 0.9, 1.6                 # 셀의 너비, 높이 (세로로 긴 직사각형)
L = 0.8                         # 가로 화살표 길이 (전부 동일)
D = 0.7                         # ⋯ 가 차지하는 폭
y₀ = 2.0                        # 셀 하단의 세로 위치
ym = y₀ + H / 2                 # 셀 중앙 높이
yl = ym + 0.42                  # 히든 스테이트 라벨 높이

# 가로 배치: 인접 셀 사이는 화살표 길이 L, ⋯ 구간은 화살표 2개 + 점 폭(2L + D)
ex = [0.75, 0.75 + W + L, 0.75 + 2W + 3L + D]        # 인코더 셀
cx = ex[3] + W + L                                    # 컨텍스트 벡터
cw = 0.8
dx1 = cx + cw + L                                     # 디코더 셀
dx = [dx1, dx1 + W + L, dx1 + 2W + 3L + D]

plot(size = (1100, 440), dpi = 300, framestyle = :none, axis = false, ticks = false,
     legend = false, xlims = (0.0, dx[3] + W + 0.3), ylims = (0.0, 6.2))

# 인코더·디코더 셀
for x in [ex; dx]
    plot!(rectangle(x, y₀, W, H), fillcolor = :white, linecolor = :black, linewidth = 1.5)
    annotate!(x + W / 2, ym, text("RNN", 11))
end

# 컨텍스트 벡터
plot!(rectangle(cx, y₀, cw, H), fillcolor = RGB(1.0, 0.95, 0.7), linecolor = :black, linewidth = 1.5)
annotate!(cx + cw / 2, ym, text(L"\mathbf{c}", 18))

# 화살표 (가로 화살표는 전부 길이 L)
harrow(xa) = plot!([xa, xa + L], [ym, ym], arrow = true, color = :black, linewidth = 1.5)
varrow(x, ya, yb) = plot!([x, x], [ya, yb], arrow = true, color = :black, linewidth = 1.5)
hlabel(xa, lab) = annotate!(xa + L / 2, yl, text(lab, 18))

# 인코더: 셀 사이로 히든 스테이트 h_t 전달
harrow(ex[1] + W); hlabel(ex[1] + W, L"\mathbf{h}_{1}")
harrow(ex[2] + W); hlabel(ex[2] + W, L"\mathbf{h}_{2}")
annotate!(ex[2] + W + L + D / 2, ym, text(L"\cdots", 14))
harrow(ex[3] - L)                          # ⋯ → 인코더 셀
harrow(ex[3] + W); hlabel(ex[3] + W, L"\mathbf{h}_{T_x}")
harrow(cx + cw)                            # 컨텍스트 벡터 → 디코더

# 디코더: 셀 사이로 히든 스테이트 s_t 전달
harrow(dx[1] + W); hlabel(dx[1] + W, L"\mathbf{s}_{1}")
harrow(dx[2] + W); hlabel(dx[2] + W, L"\mathbf{s}_{2}")
annotate!(dx[2] + W + L + D / 2, ym, text(L"\cdots", 14))
harrow(dx[3] - L)                          # ⋯ → 디코더 셀

# 인코더 입력 수열
for (x, lab) in zip(ex, [L"\mathbf{x}_{1}", L"\mathbf{x}_{2}", L"\mathbf{x}_{T_x}"])
    annotate!(x + W / 2, 0.45, text(lab, 18))
    varrow(x + W / 2, 0.95, y₀)
end

# 디코더 입력: 직전 출력 y_{t-1} (첫 셀은 컨텍스트 벡터만 받음)
for (x, lab) in zip(dx[2:3], [L"\mathbf{y}_{1}", L"\mathbf{y}_{T_y - 1}"])
    annotate!(x + W / 2, 0.45, text(lab, 18))
    varrow(x + W / 2, 0.95, y₀)
end

# 디코더 출력 수열
for (x, lab) in zip(dx, [L"\mathbf{y}_{1}", L"\mathbf{y}_{2}", L"\mathbf{y}_{T_y}"])
    varrow(x + W / 2, y₀ + H, y₀ + H + 0.85)
    annotate!(x + W / 2, y₀ + H + 1.35, text(lab, 18))
end

# 그룹 라벨
annotate!(ex[2] + W / 2, 4.35, text("Encoder", 13))
annotate!(dx[1] + W + L / 2, 5.7, text("Decoder", 13))

savefig(joinpath(@__DIR__, "3539_1.png"))

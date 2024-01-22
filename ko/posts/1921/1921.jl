cd = @__DIR__

using Plots

# p1 = plot([1 2 3; 2 3 4], ones(2, 3), fillrange = 2,
#             fillcolor = ["rgb(255, 0, 0)"          # 정수로 표현된 RGB 빨간색
#                          "rgba(0, 255, 0, 0.5)"    # 투명도가 0.5인 RGB 초록색
#                          "rgb(50%, 0%, 100%)"        # 퍼센테이지로 표현된 RGB 보라색
#                         ],
#                         dpi = 300
# )

# using Plots
r = "#FF0000"      # R빨간색 RGB(255, 0, 0)의 6자리 HEX 코드
g = "#00FF0033"    # 투명도가 0.2인 초록색 RGBA(0, 255, 0, 0.2)의 8자리 HEX 코드
p = "#80F"         # 보라색 RGB(255, 0, 136)의 3자리 HEX 코드
plot(
    plot(rand(15), lc = r, lw = 4),
    bar(rand(15), fc = g),
    scatter(rand(15), mc = p, ms = 7),
    layout = (3, 1), dpi = 300, size = (600, 450),
    label = ["\"#FF0000\"" "\"#00FF0033\"" "\"#80F\""],
)
savefig(cd*"/1921_1.png")


r = colorant"#FF0000"      # R빨간색 RGB(255, 0, 0)의 6자리 HEX 코드
g = colorant"#00FF0033"    # 투명도가 0.2인 초록색 RGBA(0, 255, 0, 0.2)의 8자리 HEX 코드
p = colorant"#80F"         # 보라색 RGB(255, 0, 136)의 3자리 HEX 코드

plot(
    plot(rand(15), lc = r, lw = 4),
    bar(rand(15), fc = g),
    scatter(rand(15), mc = p, ms = 7),
    layout = (3, 1), dpi = 300, size = (600, 450),
    label = [" colorant\"#FF0000\"" " colorant\"#00FF0033\"" " colorant\"#80F\""],
)
savefig(cd*"/1921_2.png")
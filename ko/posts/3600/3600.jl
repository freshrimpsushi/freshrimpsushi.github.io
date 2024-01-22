cd = @__DIR__

using Plots

# p1 = plot([1 2 3; 2 3 4], ones(2, 3), fillrange = 2,
#             fillcolor = ["rgb(255, 0, 0)"          # 정수로 표현된 RGB 빨간색
#                          "rgba(0, 255, 0, 0.5)"    # 투명도가 0.5인 RGB 초록색
#                          "rgb(50%, 0%, 100%)"        # 퍼센테이지로 표현된 RGB 보라색
#                         ],
#                         dpi = 300
# )

using Plots
r = "rgb(255, 0, 0)"          # 정수로 표현된 RGB 빨간색
g = "rgba(0, 255, 0, 0.2)"    # 투명도가 0.5인 RGB 초록색
p = "rgb(50%, 0%, 100%)"      # 퍼센테이지로 표현된 RGB 보라색
plot(
    plot(rand(15), lc = r, lw = 4),
    bar(rand(15), fc = g),
    scatter(rand(15), mc = p, ms = 7),
    layout = (3, 1), dpi = 300, size = (600, 450),
    label = ["\"rgb(255, 0, 0)\"" "\"rgba(0, 255, 0, 0.5)\"" "\"rgb(50%, 0%, 100%)\""],
)
savefig(cd*"/3600_1.png")


r = colorant"rgb(255, 0, 0)"          # 정수로 표현된 RGB 빨간색
g = colorant"rgba(0, 255, 0, 0.2)"    # 투명도가 0.5인 초록색
p = colorant"rgb(50%, 0%, 100%)"      # 퍼센테이지로 표현된 RGB 보라색

plot(
    plot(rand(15), lc = r, lw = 4),
    bar(rand(15), fc = g),
    scatter(rand(15), mc = p),
    layout = (3, 1), ms = 7, dpi = 300, size = (600, 450),
    label = [" colorant\"rgb(255, 0, 0)\"" " colorant\"rgba(0, 255, 0, 0.5)\"" " colorant\"rgb(50%, 0%, 100%)\""],
)
savefig(cd*"/3600_2.png")
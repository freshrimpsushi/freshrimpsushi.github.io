# 온도 소프트맥스 삽화 (지식 증류)
# 같은 로짓에 대해 온도 T 를 키우면 클래스 확률 분포가 점점 부드러워진다(고르게 퍼진다).
# T = 1 (통상) / T = 3 (조금 큼) / T = 10 (많이 큼) 세 경우를 1행 3열로 그린다.
using Plots
gr()

# 손글씨 숫자 "2" 를 분류한다고 할 때의 로짓 예시(0~9).
# 정답 클래스 2 가 지배적이고, 3·7 이 부산물로 조금 더 높다.
labels = string.(0:9)
z = [1.0, 0.5, 8.0, 3.0, 1.2, 0.8, 0.3, 2.5, 1.5, 1.0]

# 온도 소프트맥스
function softmax_T(z, T)
    e = exp.(z ./ T)
    e ./ sum(e)
end

Ts = (1.0, 3.0, 10.0)
titles = ("T = 1", "T = 3", "T = 10")

plt = plot(layout = (1, 3), size = (960, 320), legend = false, dpi = 300,
           bottom_margin = 6Plots.mm, left_margin = 6Plots.mm,
           titlefontsize = 12, tickfontsize = 9)

for (k, T) in enumerate(Ts)
    q = softmax_T(z, T)
    bar!(plt, labels, q; subplot = k, title = titles[k],
         ylims = (0, 1), fillcolor = :royalblue, linecolor = :royalblue,
         xlabel = "class", ylabel = (k == 1 ? "probability" : ""))
end

out = joinpath(@__DIR__, "temperature_softmax.png")
savefig(plt, out)
println("saved: ", out)

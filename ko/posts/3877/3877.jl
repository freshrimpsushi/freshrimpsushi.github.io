using Plots

# 사인파 위치 인코딩 (d_model = 2, 성분 인덱스는 0부터)
d_model = 2
pe(pos) = [sin(pos / 10000^(0 / d_model)), cos(pos / 10000^(0 / d_model))]

x = [1.0, 1.0]
positions = [1, 10, 100, 1000]

p = scatter([x[1]], [x[2]], label = "x", markersize = 8, markershape = :star5,
            aspect_ratio = :equal, legend = :outerright, dpi = 300)
for pos in positions
    y = x .+ pe(pos)
    scatter!(p, [y[1]], [y[2]], label = "x + pe($pos)", markersize = 6)
end

savefig(p, "3877_1.png")

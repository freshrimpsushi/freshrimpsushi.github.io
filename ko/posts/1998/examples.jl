using Plots

name = ["Gaeul", "Yujin", "Rei", "Wonyoung", "Liz", "Leeseo"]
height = [164, 173, 170, 173, 171, 165]
bar(name, height)
bar(name, height, permute = (:y, :x))

# --------------

using Plots, LinearAlgebra
μ = -1.755
h = 0.1

f(v) = [v[1] + v[2], μ*v[2] + v[1]^2 - v[1]*v[2]]
pos = Base.product(-1.5:h:.5, -.5:h:2)
dir = f.(pos) ./ 10norm.(f.(pos))

v_ = [[-0.5,0.5]]
for _ in 1:500000
    push!(v_, v_[end] + 0.0001f(v_[end]))
end
truncated_v_ = v_[340000:460000]

p1 = quiver(first.(pos), last.(pos), quiver = (first.(dir), last.(dir)),
xlabel = "x", ylabel = "y", color = :gray, size = [600, 600])
p1 = plot(p1, first.(truncated_v_[1:60000]), last.(truncated_v_[1:60000]), color = :black, lw = 2, label = "orbit", arrow = true)
p1 = plot(p1, first.(truncated_v_[60001:80000]), last.(truncated_v_[60001:80000]), color = :black, lw = 2, label = :none, arrow = true)
p1 = plot(p1, first.(truncated_v_[80001:90000]), last.(truncated_v_[80001:90000]), color = :black, lw = 2, label = :none, arrow = true)
p1 = plot(p1, first.(truncated_v_[90001:120000]), last.(truncated_v_[90001:120000]), color = :black, lw = 2, label = :none, arrow = true)
p1 = scatter(p1, [0], [0], color = :black, label = "saddle node", shape = :rect)
png(p1, "saddle_orbit.png")
anim = @animate for tk in 1:1000:460001
    plot(p1, first.(v_[1:100:tk]), last.(v_[1:100:tk]), lw = 1, color = :blue, label = :none, arrow = true)
end
mp4(anim, "saddle_orbit.mp4", fps = 30)

using Plots, LinearAlgebra
μ = -1.755
h = 0.1

f(v) = [v[1] + v[2], μ*v[2] + v[1]^2 - v[1]*v[2]]

pos = collect(Base.product(-1.5:0.001:.5, -.5:0.001:2))
dir = f.(pos)
x_ = first.(dir)
y_ = last.(dir)
null_x = .!iszero.([diff(x_ .> 0, dims = 1); zeros(Int64, 1, size(x_, 2))] +
[diff(x_ .> 0, dims = 2) zeros(Int64, size(x_, 1), 1)])
null_y = .!iszero.([diff(y_ .> 0, dims = 1); zeros(Int64, 1, size(y_, 2))] +
[diff(y_ .> 0, dims = 2) zeros(Int64, size(y_, 1), 1)])
plot(xlims = [-1.5,.5], ylims = [-.5,2], xlabel = "x", ylabel = "y", size = [600, 600])
scatter!(first.(pos[null_x]), last.(pos[null_x]), label = "dx/dt = 0", color =  :red, msw = 0, alpha = .5, ms = 0.5)
scatter!(first.(pos[null_y]), last.(pos[null_y]), label = "dy/dt = 0", color = :blue, msw = 0, alpha = .5, ms = 0.5)
png("null_clines.png")

using Optim

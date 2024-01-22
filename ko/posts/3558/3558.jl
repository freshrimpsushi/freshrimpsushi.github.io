using Plots

x = range(0, 2π, 100)
plot(x, sin.(x), label="", ylims=(-1.3,1.3), dpi=300, size=(600, 300))
plot!([π/2, 3], [1, 1.1], arrow=:true, color=:black, label="")
annotate!(3.7, 1.1, "maximum")
png("3558_1")

plot!([3π/2, 3], [-1, -1.1], arrow=:open, color=:red, label="")
annotate!(2.3, -1.1, "minimum")
png("3558_2")

plot!([π/2, π/2], [0, 1], arrow=(:closed, :both), color=:purple, label="")
annotate!(0.75π, 0.5, "amplitude")
png("3558_3")

plot!([0, 2π], [-0.1, -0.1], arrow=(:both), headlength=1)
plot!([0, 2π], [-0.3, -0.3], arrow=(:both), headlength=0.2)
plot!([0, 2π], [-0.5, -0.5], arrow=((:both), headlength=10))

arrow([0, -0.1], [2π, -0.1], arheadlength=1, color=:black, label="")

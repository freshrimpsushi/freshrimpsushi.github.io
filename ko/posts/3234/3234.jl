using Plots

N=1000
θ = LinRange(0, 2π, N)
prtb = 0.05*randn(N)
x = θ .* cos.(θ)
y = sin.(θ)

plot(x[1:Int(N/2)], y[1:Int(N/2)])
plot!(x[Int(N/2)+1:N], y[Int(N/2)+1:N])

scatter(x, y, aspect_ratio=:equal, legend=false, grid=false, frame=:none, axis=false, color=:black, linewidth=0.5)
using Plots

N = 10
len = 11
x = 0:10
y = 0:10
z = 0:10

plot(N*ones(len), y, zeros(len), color="black", linewidth=2, ls=:dash, xlims=(-N, 2N), ylims=(-N, 2N))
plot!(x, N*ones(len), zeros(len), color="red", linewidth=2, ls=:dash, camera=(110, 15))
plot!(x, y, N*ones(len), color="blue", linewidth=2, ls=:dash)
plot!(N*ones(len), N*ones(len), z, color="green", linewidth=2, ls=:dash)
plot!(x, y, z, color="black", linewidth=2, label="")
plot!(-20:20, zeros(41), zeros(41), lc=:black, lw=1, label="")
plot!(zeros(41), -20:20, zeros(41), lc=:black, lw=1, label="")
plot!(zeros(16), zeros(16), 0:15, lc=:black, lw=1, label="")
plot!(framestyle=:none, ticks=false)
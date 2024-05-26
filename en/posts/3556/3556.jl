using Plots

θ = range(0, 2π, length=100)
x = sin.(2θ)
y = cos.(2θ)
z = θ

plot(x, y, z, xlabel="x", ylabel="y", zlabel="z")
cd = @__DIR__
savefig(cd*"/3556_1.png")

anim = @animate for i ∈ 0:2:360
    plot(x, y, z, xlabel="x", ylabel="y", zlabel="z", camera=(30,i), title="altitude = $i")
end
gif(anim, cd*"/3556_1.gif", fps=30)


anim = @animate for i ∈ 0:2:360
    plot(x, y, z, xlabel="x", ylabel="y", zlabel="z", camera=(i,30), title="azimuth = $i")
end
gif(anim, cd*"/3556_2.gif", fps=30)


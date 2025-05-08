using Distributions, Plots

d1 = Normal(5, 1)
d2 = Normal(-4, 1)
d3 = Normal(0, 1.5)

x = -10:0.01:10
y1 = pdf.(d1, x)
y2 = pdf.(d2, x)
y3 = pdf.(d3, x)

plot(x, y, lw=4, label="0.5N(5,1) + 0.25N(-4,1) + 0.25N(0,1.5)")
plot!(x, y1, label="N(5, 1)", lw=2, xlabel="x", ylabel="p(x)", xlims=(-10, 10), ylims=(0, 0.7), size=(728, 400), leftmargin=15Plots.px, bottommargin=15Plots.px, dpi=300)
plot!(x, y2, label="N(-4, 1)", lw=2)
plot!(x, y3, label="N(0, 1.5)", lw=2)
savefig("D:/admin/content/j_/0_recent/3639_혼합분포/3639_4.png")

d = MixtureModel([d1, d2, d3], [1/2, 1/4, 1/4])
y = pdf.(d, x)
p = plot(x, y, lw=3, dpi=300, xlabel="x", ylabel="p(x)", label="",
xlims=(-10, 10), ylims=(0, 0.22), legend=:topleft, size=(728, 400))
savefig("D:/admin/content/j_/0_recent/3639_혼합분포/3639_1.png")

plot(p, x, pdf.(Normal(-2.5, 4), x), lw=3, label="", size=(728, 200), leftmargin=15Plots.px)
savefig("D:/admin/content/j_/0_recent/3639_혼합분포/3639_2.png")

plot(p, x, pdf.(Normal(5, 2), x), lw=3, label="", size=(728, 200), leftmargin=15Plots.px)
savefig("D:/admin/content/j_/0_recent/3639_혼합분포/3639_3.png")

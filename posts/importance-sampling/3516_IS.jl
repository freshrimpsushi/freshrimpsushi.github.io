using Distributions
using Plots

x = range(-5, 5, length=1000)
N = pdf.(Normal(), x)
C = pdf.(Cauchy(), x)

plot(x,N, label="normal distribution", ylims=(0,0.42))
plot!(x,C, label="Cauchy distribution", size=(728,400),dpi=300)
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3516_중요도샘플링/3516_IS.png")
plot!(x, N ./ C, label="importance sampling weight")
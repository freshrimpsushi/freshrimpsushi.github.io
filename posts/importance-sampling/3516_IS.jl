using Distributions
using Plots

x = range(-5, 5, length=1000)
N = pdf.(Normal(), x)
C = pdf.(Cauchy(), x)

plot(x,N, label="standard normal distribution")
plot!(x,C, label="Cauchy distribution")
plot!(x, N ./ C, label="importance sampling weight")
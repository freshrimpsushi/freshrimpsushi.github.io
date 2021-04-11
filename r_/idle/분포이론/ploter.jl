using Random
using Distributions
using Plots

cd(@__DIR__)
pwd()

Random.seed!(0)

snapshot = @animate for p in 0:0.01:1
    n = 100
    X = Binomial(n, p)
    plot(pdf(X, 1:n),
     size = (400,200), color = :black, legend = :none,
     title = "p = $p")
    xlims!(0,n); ylims!(0,0.2)
end

gif(snapshot,"Binomial_p.gif")

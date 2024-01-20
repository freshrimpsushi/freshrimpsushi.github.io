using Plots


using Distributions

function MC(n)
    x = rand(Uniform(0,1),n)
    y = rand(Uniform(0,1),n)
    z = x.^2 + y.^2
    return 4*sum(z.<=1)/n
end

MC(100)
MC(1000)
MC(10000)
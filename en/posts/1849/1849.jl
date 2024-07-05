using Plots

begin
    r = 0.2
    plot(dpi=300, size=(728, 300), ratio=1, legend=false, framestyle=:none)
    plot!([0, 1], [0, 0], lc=:black, lw=2)
    plot!([0, 0.5], [0, cos(π/4)], lc=:black, lw=2)
    plot!([0.5, 1], [cos(π/4), 0], lc=:black, lw=2)
    plot!(r .* cos.(0:0.001:π/4 .+ 0.15), r .* sin.(0:0.001:π/4 .+ 0.15), lc=:black, lw=2)
    annotate!(0.2, 0.1, text("θ=π/4", 15, :left, :black))
end
using Plots
using LaTeXStrings

x = LinRange(0, 1, 100)
θ = π/4
y = tan(θ) .* x

begin
    p = plot(x, zeros(100), lc = :black, lw = 2, label = "", figsize = (5, 5), xlim = (-0.1, 1.1), ratio = 1, framestyle = :none, dpi = 300)
    plot!(x, y, lc = :black, lw = 2, label = "")
    plot!([1, 1], [0, y[end]], lc = :black, lw = 2, label = "")
    plot!([cos(θ), cos(θ)], [0, tan(θ) * cos(θ)], lc = :black, lw = 2, label = "")
    plot!(x[71:end], (1 .- x[71:end].^2).^(1/2), lc = :black, lw = 2, label = "")
    plot!(LinRange(0.145,0.2,100), (0.2^2 .- LinRange(0.145,0.2,100).^2).^(1/2), lc = :black, lw = 2, label = "")
    annotate!(0.2, 0.09, text(L"\theta", 15, :left))
    annotate!(-0.25, 0.0, text(L"(0, 0) = O", 12, :left))
    annotate!(1.01, 0, text(L"A = (1, 0)", 12, :left))
    annotate!(1.01, tan(θ), text(L"C", 12, :left))
    annotate!(cos(θ)-0.06, sin(θ)+0.01, text(L"B", 12, :left))
    annotate!(cos(θ)-0.06, 0.03, text(L"H", 12, :left))
end

cd = @__DIR__
savefig(cd * "/3567_1.png")
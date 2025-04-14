using Distributions, LinearAlgebra, Plots
using LaTeXStrings

k(u, v) = exp(-abs2(u - v) / 2)
x = LinRange(-5, 5, 1000)
Σ = [k(x[i],x[j]) for i ∈ 1:1000, j ∈ 1:1000]

ϵ = 1e-6
Σ += ϵ*I

y = rand(MvNormal(zeros(1000), Σ))
t = LinRange(-4.5, 4.5, 8)
t_str = [LaTeXString("\$t_{$i}\$") for i ∈ 1:8]
begin
    plot(x, y, size=(800,400), dpi=200,
        legend = :none, lw = 2, ls=:dash, lc=:black, α = 0.5,
        xlims=(-6,6), showaxis=:x, grid=false, ylims=(-3.5,1.5),
        xticks=(t, t_str), xtickfont=font(14)
        )
    plot!([t[1], t[1]], [-305, y[51]], ls=:dash, lc=:gray)
    plot!([t[2], t[2]], [-305, y[179]], ls=:dash, lc=:gray)
    plot!([t[3], t[3]], [-305, y[307]], ls=:dash, lc=:gray)
    plot!([t[4], t[4]], [-305, y[435]], ls=:dash, lc=:gray)
    plot!([t[5], t[5]], [-305, y[563]], ls=:dash, lc=:gray)
    plot!([t[6], t[6]], [-305, y[691]], ls=:dash, lc=:gray)
    plot!([t[7], t[7]], [-305, y[819]], ls=:dash, lc=:gray)
    plot!([t[8], t[8]], [-305, y[947]], ls=:dash, lc=:gray)
    scatter!(t, y[[51, 179, 307, 435, 563, 691, 819, 947]], markersize=6, markercolor=:black)
    annotate!([
        (t[1]+0.2, y[51 ], text(L"\mathbf{h}_{1}", :black, 15, :left)),
        (t[2]+0.12, y[179]+0.14, text(L"\mathbf{h}_{2}", :black, 15, :left)),
        (t[3]+0.15, y[307]+0.2, text(L"\mathbf{h}_{3}", :black, 15, :left)),
        (t[4]-0.15, y[435]+0.24, text(L"\mathbf{h}_{4}", :black, 15, :left)),
        (t[5]+0.15, y[563], text(L"\mathbf{h}_{5}", :black, 15, :left)),
        (t[6]+0.2, y[691], text(L"\mathbf{h}_{6}", :black, 15, :left)),
        (t[7]-0.5, y[819], text(L"\mathbf{h}_{7}", :black, 15, :left)),
        (t[8]+0.2, y[947], text(L"\mathbf{h}_{8}", :black, 15, :left))
    ])
    savefig(cd*"/3159_1.png")
end
cd = @__DIR__
save(cd*"/y.jld2", "y", y)
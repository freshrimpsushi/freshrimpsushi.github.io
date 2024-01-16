using Plots
using LaTeXStrings
cd = @__DIR__


x = 0:0.01:1
function y(x, m)
    a_m = 0.5 + 1/m
    if x ≤ 0.5
        return 0
    elseif 0.5 < x ≤ a_m
        return m*(x - 0.5)
    elseif a_m < x ≤ 1
        return 1
    end
end

begin
    p₁ = plot(dpi = 300, legend = :none)
    vline!([0.5, 0.5+1/3], lc = :black, ls = :dash)
    plot!(x, (x -> y(x, 3)).(x), xlims = (0,1), ylims = (-0.008,1.2), lw = 5,
        xticks = ([0, 0.5, 0.5+1/3, 1], [L"0", L"\frac{1}{2}", L"a_m", L"1"]),
        yticks = ([0, 1], [L"0", L"1"]),
        tickfontsize = 10,
        color = :blue,
        lc = palette(:default)[1]
    )
    plot!([0.5, 0.5+1/3], [1.1, 1.1], color = :black, arrow = :both)
    annotate!((0.5+0.5+1/3)/2, 1.1, text(L"\frac{1}{m}", :bottom, 10))
    annotate!((0.5+0.5+1/3)/2, 0.6, text(L"x_n", :bottom, 15, palette(:default)[1]))
end

begin
    p₂ = plot(dpi = 300, legend = :none)
    vline!([0.5], lc = :black, ls = :dash)
    plot!([0.5+1/5, 0.5+1/5], [1.0, 1.22], color = :black, ls = :dash)
    plot!([0.5+1/3, 0.5+1/3], [1.0, 1.3], color = :black, ls = :dash)
    plot!(x, (x -> y(x, 3)).(x), xlims = (0,1), ylims = (-0.008,1.3), lw = 5,
    xticks = ([0, 0.5, 1], [L"0", L"\frac{1}{2}", L"1"]),
    yticks = ([0, 1], [L"0", L"1"]),
    tickfontsize = 10,
    color = :blue,
    lc = palette(:default)[1]
    )
    plot!(x, (x -> y(x, 5)).(x), xlims = (0,1), ylims = (-0.008,1.3), lw = 5,
    tickfontsize = 10,
    color = :blue,
    lc = palette(:default)[1]
    )
    plot!([0.5, 0.5+1/3], [1.22, 1.22], color = :black, arrow = :both)
    plot!([0.5, 0.5+1/5], [1.1, 1.1], color = :black, arrow = :both)
    annotate!((0.5+0.5+1/3)/2, 1.22, text(L"\frac{1}{m}", :bottom, 10))
    annotate!((0.5+0.5+1/5)/2, 1.1, text(L"\frac{1}{n}", :bottom, 10))
    annotate!((0.5+0.5+1/4)/2 - 0.03, 0.75, text(L"x_n", :bottom, 15, palette(:default)[1]))
    annotate!((0.5+0.5+1/2)/2 + 0.03, 0.55, text(L"x_m", :bottom, 15, palette(:default)[1]))
end

p = plot(p₁, p₂, size = (700, 400), dpi = 300,
    title = ["(a)" "(b)"]
)
savefig(p, joinpath(cd, "1594_1.png"))


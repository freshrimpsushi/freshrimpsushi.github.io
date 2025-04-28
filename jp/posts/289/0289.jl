using Plots, LaTeXStrings

plot([-2,10], [0, 0], lw=1, lc=:black, xlims=(-2,10), ylims=(-0.5,11), framestyle=:none, label="", size=(728,400), dpi=200)
plot!([0, 0], [-0.5, 10], lw=1, lc=:black, label="")
plot!([-2, 0], [10, 10], lw=3, lc=:red, label="")
plot!([4, 10], [10, 10], lw=3, lc=:red, topmargin=5*Plots.mm, label="", xtickfont = font(14), ytickfont = font(14))
plot!([0, 0], [0, 10], lw=3, lc=:red, label="")
plot!([4, 4], [0, 10], lw=3, lc=:red, label="")
plot!([0, 4], [0, 0], lw=3, lc=:red, label=L"V(x)", legend=:right, legendfont = font(14))
annotate!(-0.2, -0.4, text(L"0"))
annotate!(4, -0.5, text(L"a"))
annotate!(-0.2, 10.5, text(L"\infty"))
annotate!(10, -0.4 , text(L"x"))

cd = @__DIR__
savefig(joinpath(cd, "0289_1.png"))
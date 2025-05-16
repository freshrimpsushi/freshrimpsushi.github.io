@time using LaTeXStrings
@time using Distributions
@time using Plots

cd(@__DIR__)

x = -10:0.1:10
B = collect(0.1:0.1:5.0); append!(B, reverse(B))

animation = @animate for b ∈ B
    plot(x, pdf.(Laplace(0, b), x),
     color = :black,
     label = "b = $(round(b, digits = 2))", size = (400,300))
    xlims!(-10,10); ylims!(0,1); title!(L"\mathrm{pdf\,of\,} \operatorname{Laplace}(0, b)")
end
gif(animation, "pdf.gif", fps = 15)


plot(x, pdf.(Laplace(0, 1), x), lw=2, label="Laplace(0, 1)", color=:royalblue, dpi=200)
plot!(x, pdf.(Normal(0, 1), x), lw=2, label="Normal(0, 1)", color=:tomato)
savefig("3644_1.png")
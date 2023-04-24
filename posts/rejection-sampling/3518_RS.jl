using Distributions
using Plots
using LaTeXStrings

# x = range(-15, 15, length=1000)

# p1 = Normal(-3, 0.8)
# p2 = Normal(3, 3)
# pdf_p1 = 0.5*pdf.(p1, x)
# pdf_p2 = pdf.(p2, x)
# plot(x, 4.2*pdf.(Normal(0,5), x), label="proposal "*L"kq(x)", framestyle=:none)
# hline!([0], color=:black, label="")
# plot!(x, pdf_p1+pdf_p2, label="target "*L"p(x)", dpi=300, size=(728,300), color=palette(:tab10)[2])
# savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3518_리젝션샘플링/3518_RS.png")

# p₀ = 0.5*pdf.(p1, 0) + pdf.(p2, 0) #0.08087
# kq₀ = 4.2*pdf.(Normal(0,5), 0) #0.33511
# plot(x, 4.2*pdf.(Normal(0,5), x), label="proposal "*L"kq(x)", framestyle=:none)
# hline!([0], color=:black, label="")
# plot!(x, pdf_p1+pdf_p2, label="target "*L"p(x)", dpi=300, size=(728,300), color=palette(:tab10)[2])
# plot!([0, 0], [0, p₀], arrow=(:closed, :both), color=:blue, label="")
# annotate!(6, 0.5p₀, text("probability that "*L"x_{i}"*" is accepted", :blue, 10))
# plot!([0, 0], [p₀, kq₀], arrow=(:closed, :both), color=:red, label="")
# annotate!(6, p₀ + 0.5(kq₀ - p₀), text("probability that "*L"x_{i}"*" is rejected", :red, 10))
# annotate!([0], [-0.02], text(L"x_{i}", :black, 10))
# savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3518_리젝션샘플링/3518_RS2.png")

N = 20000
target(x) = 0.5*pdf.(Normal(-3, 0.8), x) + pdf.(Normal(3, 3), x)
proposal = Normal(0, 5)
samples = Float64[]
accepted = Array{Float64}[]
rejected = Array{Float64}[]
for i ∈ 1:N
    x = rand(proposal)
    y = rand(Uniform(0,1))
    if y < target(x)/4.2pdf(proposal, x)
        push!(samples, x)
        push!(accepted, [x, y])
    else
        push!(rejected, [x, y])
    end
end
accepted = hcat(accepted...)
rejected = hcat(rejected...)

scatter(accepted[1,:], accepted[2,:], label="accepted", color=:blue, markerstrokewidth=0, markersize=2, dpi=300, size=(728,300), legend=:topright)
scatter!(rejected[1,:], rejected[2,:], label="rejected", color=:red, markerstrokewidth=0, markersize=2)
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3518_리젝션샘플링/3518_RS3.png")

x = range(-15, 15, length=1000)
plot(x, target(x), label="target "*L"p(x)", framestyle=:none)
histogram!(samples, label="accepted samples", color=:blue, alpha=0.5, bins=100, normed=true, dpi=300, size=(728,300), legend=:topright)
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3518_리젝션샘플링/3518_RS4.png")
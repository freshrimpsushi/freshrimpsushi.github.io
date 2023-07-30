using Plots

θ = LinRange(0,2π,100)
x = sin.(θ) + 0.05randn(100)
y = cos.(θ) + 0.1randn(100)
z = ones(100) + randn(100).*sin.(θ)
p₁ = scatter(x,y,z,legend=false, ratio=1, zlims=(0,2), xlabel="x", ylabel="y", zlabel="z", formatter = (_...) -> "", dpi=300)
p₂ = scatter(x,y,legend=false, ratio=1, xlabel="x", ylabel="y", formatter = (_...) -> "", dpi=300)
plot(p₁, p₂, layout=@layout([_ _ _;p{0.5w} p{0.4w, 0.7h} _; _ _ _]), dpi=300, size=(728,350))
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3563_차원축소/3563_1.png")

using MLDatasets
using DataFrames

df = Iris().features
X = Array(df)

label = Array(Iris().targets)

p₃ = plot(layout=(4,4), size=(728, 600))
for i in 0:15
    x_ax = i÷4+1
    y_ax = i%4+1

    scatter!(p₃[i+1], X[1:50,x_ax], X[1:50,y_ax], legend=false, ratio=1, markersize=2.5)
    scatter!(p₃[i+1], X[51:100,x_ax], X[51:100,y_ax], legend=false, ratio=1, markersize=2.5)
    scatter!(p₃[i+1], X[101:150,x_ax], X[101:150,y_ax], legend=false, ratio=1, markersize=2.5)
end
display(p₃)
savefig(p₃, "C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3563_차원축소/3563_2.png", )
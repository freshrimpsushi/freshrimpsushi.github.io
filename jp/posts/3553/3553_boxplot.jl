using StatsPlots
using DataFrames
using MLDatasets

x = rand(0:100, 100)
y = rand(50:100, 100)
z = cat(x,y, dims=1)

boxplot(x, label="x", ylims=(-10, 130), dpi=300)
boxplot!(y, label="y")
boxplot!(z, label="z")
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/줄리아/3553_J박스플랏/3553_1.png")

boxplot([x,y,z], label=["x" "y" "z"])

boxplot([x, y, z], xticks=(1:3, ["x", "y", "z"]), label=["x" "y" "z"], ylims=(-10, 130), dpi=300)

savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/줄리아/3553_J박스플랏/3553_2.png")

boxplot(fill("x", length(x)), x, label="x", ylims=(-10, 130), dpi=300)
boxplot!(fill("y", length(y)), y, label="y")
boxplot!(fill("z", length(z)), y, label="z")

a = rand(100, 3)
boxplot(a, xticks=(1:3, ["x", "y", "z"]), label=["x" "y" "z"], ylims=(-0.05, 1.3), dpi=300)
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/줄리아/3553_J박스플랏/3553_3.png")

df = Iris().features
boxplot(Array(df), xticks=(1:4, names(df)), label=reshape(names(df), (1,4)), dpi=300)
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/줄리아/3553_J박스플랏/3553_4.png")

using Statistics

boxplot(fill("x", length(x)), x, labels="x", ylims=(-10, 130), dpi=300)
boxplot!(fill("y", length(y)), y, labels="y")
boxplot!(fill("z", length(z)), z, labels="z")

scatter!(["x", "y", "z"], [mean(x), mean(y), mean(z)], color=palette(:default)[1:3], label="")
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/줄리아/3553_J박스플랏/3553_5.png")

boxplot([x, y, z], xticks=(1:3, ["x", "y", "z"]), label=["x" "y" "z"], ylims=(-10, 130), dpi=300)
scatter!([1, 2, 3], [mean(x), mean(y), mean(z)], color=palette(:default)[1:3], label="")
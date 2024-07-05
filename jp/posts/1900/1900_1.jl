using Plots
using LaTeXStrings

x = 0.03:0.01:6
y = 1 ./ (x .- 1).^2 .+ 0.5
begin
    plot(x, y, xlims=(0, 5.5), ylims= (0,1.5), label = L"y = 1/x^2", color=:black, linewidth=2, dpi=300, size=(728, 400))
    bar!([0,1,2,3, 4].+0.5, 1 ./ [1, 2, 3, 4, 5].^2, alpha=0.5, color=:red, label="", bar_width=1)
    annotate!(0.5, 0.5, text("area = 1", 10, :black))
    annotate!(1.5, 0.5(1/2^2), text("area = 1/4", 10, :black))
    annotate!(2.5, 0.5(1/3^2), text("area = 1/9", 10, :black))
    annotate!(3.5, 0.5(1/4^2), text("area = 1/16", 10, :black))
    plot!([4.5, 4.5], [0.5(1/5^2), 0.21], arrow=:head, c=:black, label="")
    annotate!(4.5, 0.25, text("area = 1/25", 10, :black))
end
cd = @__DIR__
savefig(joinpath(cd, "1900_1.png"))


x = 0.0:0.01:6
y = 0.01(x .- 7).^2
begin
    plot(x[30:end], y[30:end],legend = false, color=:black, linewidth=2, dpi=300, size=(728, 300), yticks=false, framestyle=:zerolines)
    bar!([1,2,3, 4].+0.5, 0.01([2, 3, 4, 5] .- 7).^2, alpha=0.5, color=:red, label="", bar_width=1)
    annotate!(1.5, 0.02, text(L"a_2", 15, :black))
    annotate!(2.5, 0.02, text(L"a_3", 15, :black))
    annotate!(3.5, 0.02, text(L"a_4", 15, :black))
    annotate!(4.5, 0.02, text(L"a_5", 15, :black))
    plot!([1, 1], [0, 0.01*36], c=:black)
end
savefig(joinpath(cd, "1900_2.png"))

x = 0.0:0.01:6
y = 0.01(x .- 7).^2
begin
    bar([1,2,3, 4].+0.5, 0.01([1, 2, 3, 4] .- 7).^2, alpha=0.5, color=:red, label="", bar_width=1)
    plot!(x[30:end], y[30:end],legend = false, color=:black, linewidth=2, dpi=300, size=(728, 300), yticks=false, framestyle=:zerolines)
    annotate!(1.5, 0.02, text(L"a_2", 15, :black))
    annotate!(2.5, 0.02, text(L"a_3", 15, :black))
    annotate!(3.5, 0.02, text(L"a_4", 15, :black))
    annotate!(4.5, 0.02, text(L"a_5", 15, :black))
    plot!([1, 1], [0, 0.01*36], c=:black)
end
savefig(joinpath(cd, "1900_3.png"))

x = 0.1:0.01:11
y = 9 ./ x

begin
    plot(x, y, xlims=(-Inf, 11), ylims=(0,10),legend = false, color=:black, linewidth=2, dpi=300, size=(728, 300), yticks=false, framestyle=:zerolines,
    xticks = ([0,1,2,3,4,5,9,10],[0,1,2,3,4,5,"n-1","n"]))
    bar!([2,3,4,5,6,7,8,9,10].-0.5, 9 ./ [2,3,4,5,6,7,8,9,10], alpha=0.5, color=:red, label="", bar_width=1)
    annotate!(1.5, 0.5, text(L"a_2", 10, :black))
    annotate!(2.5, 0.5, text(L"a_3", 10, :black))
    annotate!(3.5, 0.5, text(L"a_4", 10, :black))
    annotate!(9.5, 0.5, text(L"a_{n}", 10, :black))
end
savefig(joinpath(cd, "1900_2.png"))

begin
    plot(x, y, xlims=(-Inf, 11), ylims=(0,10),legend = false, color=:black, linewidth=2, dpi=300, size=(728, 300), yticks=false, framestyle=:zerolines,
    xticks = ([0,1,2,3,4,5,9,10],[0,1,2,3,4,5,"n-1","n"]))
    bar!([1,2,3,4,5,6,7,8,9].+0.5, 9 ./ [1,2,3,4,5,6,7,8,9], alpha=0.5, color=:red, label="", bar_width=1)
    annotate!(1.5, 0.5, text(L"a_1", 10, :black))
    annotate!(2.5, 0.5, text(L"a_2", 10, :black))
    annotate!(3.5, 0.5, text(L"a_3", 10, :black))
    annotate!(9.5, 0.5, text(L"a_{n-1}", 10, :black))
end
savefig(joinpath(cd, "1900_3.png"))
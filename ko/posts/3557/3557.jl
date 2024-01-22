using StatsPlots

using Statistics
x = [9, 8, 7, 7, 7, 6, 6, 5, 3, 2]
Q2 = quantile(x, 0.5) 
Q3 = quantile(x, 0.75)
Q1 = quantile(x, 0.25)
median([Q3,Q1])
m = 1 + 0.25(-1)
j = Int(floor(10*0.25 + m))
g = 10*0.25 + m - j
Q = (1-g)*x[j] + g*x[j+1]

1.5(Q3-Q1)
q1, q2, q3, q4, q5 = quantile(x, range(0, stop = 1, length = 5))
q1
q2
q3
q4 

limit = 1.5 * (q4 - q2)
q2 - limit
q4 + limit
inside = Float64[]
outliers_y = zeros(0)
for value in x
    if (value < (q2 - limit)) || (value > (q4 + limit))
            push!(outliers_y, value)
    else
        push!(inside, value)
    end
end
inside
outliers_y
q1, q5 = Plots.ignorenan_extrema(inside)
q1, q5 = (min(q1, q2), max(q4, q5)) # whiskers cannot be inside the box


v = Vector(range(0, stop = 1, length = 5))
print(v)

boxplot(x, xlims=(0,2), ylims=(0,10), bar_width=0.2, xformatter = (_...) -> "", label="", dpi=300, size=(400,300))
# vline!([1.43])
# vline!([0.57])
Q2 = quantile(x, 0.5) 
Q3 = quantile(x, 0.75)
Q1 = quantile(x, 0.25)
Q4 = 9.0
Q0 = 3.0
Q3 + 1.5(Q3 - Q1)
Q1 - 1.5(Q3 - Q1)

p1 = plot([0.9, 1.1], [Q2, Q2], color=:black, label="", xlims=(0,2), ylims=(0,10), xformatter = (_...) -> "", dpi=300, size=(728/2,300))
plot!([0.9, 1.1], [Q3, Q3], color=:black, label="")
plot!([0.9, 1.1], [Q1, Q1], color=:black, label="")
plot!([0.7, 0.6], [Q2, Q2], arrow=true, color=:black, label="")
annotate!(0.435, Q2, "Q2")
plot!([1.3, 1.4], [Q3, Q3], arrow=true, color=:black, label="")
annotate!(1.565, Q3, "Q3")
plot!([0.7, 0.6], [Q1, Q1], arrow=true, color=:black, label="")
annotate!(0.435, Q1, "Q1")

p2 = heatmap(range(0.93,1.07,length=3), range(Q1+0.29,Q3-0.29,length=3), ones(3,3), color=color=palette(:default)[1], label="", colorbar=:none, xlims=(0,2), ylims=(0,10), xformatter = (_...) -> "", dpi=300, size=(728/2,300))
plot!([0.9, 1.1], [Q2, Q2], color=:black, label="")
plot!([0.9, 1.1], [Q3, Q3], color=:black, label="")
plot!([0.9, 1.1], [Q1, Q1], color=:black, label="")
plot!([0.9, 0.9], [Q1, Q3], color=:black, label="")
plot!([1.1, 1.1], [Q1, Q3], color=:black, label="")
plot!([0.7, 0.6], [Q2, Q2], arrow=true, color=:black, label="")
annotate!(0.435, Q2, "Q2")
plot!([1.3, 1.4], [Q3, Q3], arrow=true, color=:black, label="")
annotate!(1.565, Q3, "Q3")
plot!([0.7, 0.6], [Q1, Q1], arrow=true, color=:black, label="")
annotate!(0.435, Q1, "Q1")

p1
p2
plot(p1, p2, size=(728, 300), dpi=300)
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3557_상자그림/3557_2.png")

p3 = boxplot(x, xlims=(0,2), ylims=(0,10), bar_width=0.2, xformatter = (_...) -> "", label="", dpi=300, size=(728/2,300), outliers=false)
plot!([0.7, 0.6], [Q2, Q2], arrow=true, color=:black, label="")
annotate!(0.435, Q2, "Q2")
plot!([1.3, 1.4], [Q3, Q3], arrow=true, color=:black, label="")
annotate!(1.565, Q3, "Q3")
plot!([0.7, 0.6], [Q1, Q1], arrow=true, color=:black, label="")
annotate!(0.435, Q1, "Q1")
plot!([1.3, 1.4], [Q4, Q4], arrow=true, color=:black, label="")
annotate!(1.565, Q4, "Q4")
plot!([0.7, 0.6], [Q0, Q0], arrow=true, color=:black, label="")
annotate!(0.435, Q0, "Q0")

p4 = boxplot(x, xlims=(0,2), ylims=(0,10), bar_width=0.2, xformatter = (_...) -> "", label="", dpi=300, size=(728/2,300))
plot!([0.7, 0.6], [Q2, Q2], arrow=true, color=:black, label="")
annotate!(0.435, Q2, "Q2")
plot!([1.3, 1.4], [Q3, Q3], arrow=true, color=:black, label="")
annotate!(1.565, Q3, "Q3")
plot!([0.7, 0.6], [Q1, Q1], arrow=true, color=:black, label="")
annotate!(0.435, Q1, "Q1")
plot!([1.3, 1.4], [Q4, Q4], arrow=true, color=:black, label="")
annotate!(1.565, Q4, "Q4")
plot!([0.7, 0.6], [Q0, Q0], arrow=true, color=:black, label="")
annotate!(0.435, Q0, "Q0")
plot!([1.3, 1.4], [2, 2], arrow=true, color=:black, label="")
annotate!(1.69, 2, "outlier")

plot(p3, p4, size=(728, 300), dpi=300)
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3557_상자그림/3557_3.png")

y = rand(2:25, 100)
z = rand(10:40, 100)
w = rand(1:15, 100)
begin
    boxplot([1], [x], dpi=300, size=(400,300), bar_width=0.2, label="x", ylims=(-5,45), xformatter = (_...) -> "")
    boxplot!([1.5], [y], bar_width=0.2, label="y")
    boxplot!([2], [z], bar_width=0.2, label="z")
    boxplot!([2.5], [w], bar_width=0.2, label="w")
end
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3557_상자그림/3557_4.png")

annotate!(1.6, 3, "minimum")
plot!([1.15, 1.4], [9, 9], arrow=true, color=:black, label="")
annotate!(1.61, 9, "maximum")
plot!([0.85, 0.6], [Q2, Q2], arrow=true, color=:black, label="")
annotate!(0.435, Q2, "median")
plot!([1.15, 1.4], [Q3, Q3], arrow=true, color=:black, label="")
annotate!(1.67, Q3, "third quartile")
plot!([0.85, 0.6], [Q1, Q1], arrow=true, color=:black, label="")
annotate!(0.34, Q1, "first quartile")
plot!([0.85, 0.6], [2, 2], arrow=true, color=:black, label="")
annotate!(0.45, 2, "outlier")

savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3557_상자그림/3557_1.png")

x = range(0, 2π, 100)
plot(x, sin.(x), label="", ylims=(-1.3,1.3), dpi=300, size=(600,300))
plot!([π/2, 3], [1, 1.1], arrow=:true, color=:black, label="")
annotate!(3.7, 1.1, "maximum")
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3558_J화살표/3558_1.png")

plot!([3π/2, 3], [-1, -1.1], arrow=:closed, color=:red, label="")
annotate!(2.3, -1.1, "minimum")
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3558_J화살표/3558_2.png")

plot!([π/2, π/2], [0, 1], arrow=(:closed, :both), color=:purple, label="")
annotate!(0.75π, 0.5, "amplitude")
savefig("C:/Users/rydbr/Desktop/바탕화면/admin/content/j_/0_recent/3558_J화살표/3558_3.png")
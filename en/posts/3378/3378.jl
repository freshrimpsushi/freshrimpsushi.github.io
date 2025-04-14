using Plots

# 범위
n = 1:10

# 산술 수열: 첫 항 1, 공차 2
arith = [1 + 2*(i - 1) for i in n]

# 기하 수열: 첫 항 1, 공비 2
geom = [1 * 2^(i - 1) for i in n]

# Plot
plot(n, arith, label = "Arithmetic Growth (Addition)", lw = 2, marker = :circle, size=(728,400), dpi=250)
plot!(n, geom, label = "Geometric Growth (Multiplication)", lw = 2, marker = :star)
xlabel!("Index (n)")
ylabel!("Value")
title!("Arithmetic vs Geometric Growth")
cd = @__DIR__
savefig(cd*"/3378_1.png")

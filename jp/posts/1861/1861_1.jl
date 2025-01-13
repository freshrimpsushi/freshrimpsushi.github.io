function mysin(x)
    S = [-1.66666666666666324348e-01,
         8.33333333332248946124e-03,
         -1.98412698298579493134e-04,
         2.75573137070700676789e-06,
         -2.50507602534068634195e-08,
         1.58969099521155010221e-10]
    sinx = x +  S[1]*x^3 + S[2]*x^5 + S[3]*x^7 + S[4]*x^9 + S[5]*x^11 + S[6]*x^13
    return sinx
end

sin(0.672)
mysin(0.672)

S = [-1.66666666666666324348e-01,
         8.33333333332248946124e-03,
         -1.98412698298579493134e-04,
         2.75573137070700676789e-06,
         -2.50507602534068634195e-08,
         1.58969099521155010221e-10]
x = 0:0.01:π/4
y = sin.(x)
y1 = x 
y2 = x .+ S[1]*x.^3
y3 = x .+ S[1]*x.^3 .+ S[2]*x.^5
y4 = x .+ S[1]*x.^3 .+ S[2]*x.^5 .+ S[3]*x.^7
y5 = x .+ S[1]*x.^3 .+ S[2]*x.^5 .+ S[3]*x.^7 .+ S[4]*x.^9
y6 = x .+ S[1]*x.^3 .+ S[2]*x.^5 .+ S[3]*x.^7 .+ S[4]*x.^9 .+ S[5]*x.^11
s₀ = x .+ S[1]*x.^3 .+ S[2]*x.^5 .+ S[3]*x.^7 .+ S[4]*x.^9 .+ S[5]*x.^11 .+ S[6]*x.^13

using Plots
p1 = plot(x, y, label="sin(x)", linewidth=8, dpi=300, size=(728,300))
plot!(x, y1, label="n=1", linewidth=2, ls=:dash)
plot!(x, y3, label="n=3", linewidth=2, ls=:dash, lc=:red)
plot!(x, y5, label="n=5", linewidth=2, ls=:dash)
plot!(x, y7, label="s_6", linewidth=3, ls=:dash, lc=:red)
cd = @__DIR__
savefig(p1, joinpath(cd, "1861_2.png"))
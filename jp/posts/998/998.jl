using Plots

cd = @__DIR__

function SB(n)
    return 1 - factorial(big(365))/(big(365)^n*(factorial(big(365-n))))
end

x = 2:365
y = SB.(x)

begin
    p1 = plot(x,y, dpi=300, label="", xlabel="n", ylabel="p(n)", lw=3)
    plot!(size=(728,300), bottom_margin=10Plots.px, left_margin=10Plots.px)
    plot!(xlims=(2,365), ylims=(0,1.2))
    plot!([23,23], [0,SB(23)], label="", ls=:dash, lc=:orange)
    plot!([2,23], [SB(23),SB(23)], label="", ls=:dash, lc=:orange)
    plot!([41,41], [0,SB(41)], label="", ls=:dash, lc=:red)
    plot!([2,41], [SB(41),SB(41)], label="", ls=:dash, lc=:red)
    plot!(xticks=([2,23,41,100,200,300,365]))
    plot!(yticks=([0.00, 0.25, 0.50, 0.75, 0.90, 1.00]))
    p2 = plot(x[1:50], y[1:50], dpi=300, label="", xlabel="n", ylabel="p(n)", lw=3)
    plot!(xlims=(2,Inf), ylims=(0,1.2))
    plot!(xticks=([2,5, 10, 15, 20, 23, 25, 30, 35, 41, 50]))
    plot!([23,23], [0,SB(23)], label="", ls=:dash, lc=:orange)
    plot!([2,23], [SB(23),SB(23)], label="", ls=:dash, lc=:orange)
    plot!([41,41], [0,SB(41)], label="", ls=:dash, lc=:red)
    plot!([2,41], [SB(41),SB(41)], label="", ls=:dash, lc=:red)
    plot!(yticks=([0.00, 0.25, 0.50, 0.75, 0.90, 1.00]))
    plot(p1, p2, layout=(2,1), size=(728,600))
    savefig(cd*"/998_1.png")
end
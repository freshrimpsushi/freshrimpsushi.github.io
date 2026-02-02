using Plots

p1 = scatter([1,2,3], [0], msize=[10,20,30],
            xlims=(0,4), ylims=(-2,2), label="", size=(728,300), dpi=300,
            title="marker size comparison", titlefontsize=12)
p2 = scatter([1,2,3], [0], msw=[5,10,15], ms=[30],
            xlims=(0,4), ylims=(-2,2), label="", size=(728,300), dpi=300,
            title="marker stroke width comparison", titlefontsize=12)
plot(p1, p2)
savefig(joinpath(@__DIR__, "3719_1.png"))


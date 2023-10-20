using Plots
√2
γ(s) = [√2/2 *cos(√2s), √2/2 *sin(√2s), √2/2]

s = LinRange(0, 2π, 100)
curve = γ.(s)
M = hcat(curve...)'
t′(s) = [-√2 *cos(√2s), -√2 *sin(√2s), -√2]

T′ = t′.(s)
T′ = hcat(T′...)'

plot(M[:,1], M[:,2], M[:,3], aspect_ratio=:equal, legend=false, xlims=(-1,1), ylims=(-1,1), zlims=(-1,1))
plot(T′[:,1], T′[:,2], T′[:,3], aspect_ratio=:equal, legend=false)#, xlims=(-1,1), ylims=(-1,1), zlims=(-1,1))

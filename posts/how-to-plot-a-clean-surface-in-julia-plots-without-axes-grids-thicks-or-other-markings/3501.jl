using Plots
using MAT

cd = @__DIR__

matfile = matopen(cd*"/surface.mat")

L = read(matfile, "L")

s = surface(L, camera=(-45,30))

surface(s, title="Fig. 1", )
savefig(cd*"/fig1.png")

surface(s, title="Fig. 2", colorbar=:none, showaxis=false, grid=false)
savefig(cd*"/fig2.png")
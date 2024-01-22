using Plots
using MAT

cd = @__DIR__

matfile = matopen(cd*"/surface.mat")

L_ = read(matfile, "L")

L = surface(L_, camera=(-45,30))

s1 = surface(L, title="default")
savefig(cd*"/fig1.png")
s2 = surface(L, title="colorbar=:none", colorbar=:none)
savefig(cd*"/fig2.png")
s3 = surface(L, title="showaxis=false", showaxis=false)
savefig(cd*"/fig3.png")
s4 = surface(L, title="grid=false", grid=false)
savefig(cd*"/fig4.png")
s5 = surface(L, title="ticks=false", ticks=false)
savefig(cd*"/fig5.png")
s6 = surface(L, title="framestyle=:none", framestyle=:none)
savefig(cd*"/fig6.png")
s7 = surface(L, title="all off", ticks=false, framestyle=:none, colorbar=:none)
savefig(cd*"/fig7.png")

savefig(cd*"/fig2.png")
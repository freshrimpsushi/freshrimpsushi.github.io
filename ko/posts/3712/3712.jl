using Plots

save_dir = "./content/j_/0_recent/3712_26겨울오마카세/"
AH(r) = 100r/(100-r)
r = 0:1:90
plot(r, AH.(r), lw=2, xlabel="Cooldown Reduction", ylabel="Ability Haste", legend=false, dpi=300, size=(728,400))
plot!(xticks=0:10:90, yticks=AH.([10, 30, 50, 70, 80, 90]).|>round, xlim=(0,93), ylim=(0,AH(r[end])))
for i ∈ 10:10:50
    annotate!(i, round.(AH(i))+20, text("$(round.(AH(i)).|> Int)", 8, :center))
end
for i ∈ 60:10:80
    annotate!(i, round.(AH(i))+20, text("$(round.(AH(i)).|> Int)", 8, :right))
end
annotate!(90-0.5, round.(AH(90)), text("$(round.(AH(90)).|> Int)", 8, :right))
plot!(left_margin=5mm)
savefig(save_dir * "3712_1.png")

PDR(ar) = 100ar/(100+ar)
PDR_df(ar) = 10000/((100+ar)^2)
ar = 0:1:750
p2_1=plot(ar, PDR.(ar), lw=2, xlabel="Armor", ylabel="Physical Damage Reduction", legend=false, dpi=300, size=(728,400))
plot!(xticks=0:50:500, yticks=0:10:90, xlim=(0,525), ylim=(0,99))
plot!(left_margin=5mm)
plot!(title="Physical Damage Reduction by Armor")
savefig(save_dir * "3712_2.png")

p2_2 = plot(ar, PDR_df.(ar), lw=2, xlabel="Armor", ylabel="Physical Damage Reduction per 1 Armor", legend=false, dpi=300, size=(728,400))
plot!(xticks=0:50:500, xlim=(0,525), ylim=(0,1), yticks=[0.0, 0.2, PDR_df(100), 0.4, round(PDR_df(50); digits=2), 0.6, 0.8, 1.0])
plot!([0, 50], [round(PDR_df(50); digits=2), round(PDR_df(50); digits=2)], lc=:black, ls=:dash)
plot!([50, 50], [0, PDR_df(50)], lc=:black, ls=:dash)
plot!([0, 100], [PDR_df(100), PDR_df(100)], lc=:black, ls=:dash)
plot!([100, 100], [0, PDR_df(100)], lc=:black, ls=:dash)
plot!(left_margin=5mm)
plot!(title="Physical Damage Reduction Increase per 1 Armor")
savefig(save_dir * "3712_3.png")
# plot!(p2_1, p2_2, layout=(2,1))

cd = @__DIR__

using Plots

cgrad(:inferno)


A = reshape(1:25, 5,5)
p₁= heatmap(A)

for i ∈ 1:5
    for j ∈ 1:5
        if j ∈ 1:3
            color = :white
        else
            color = :black
        end
        p₁ = annotate!([j], [i], text(A[i,j], :center, 10, color))
    end
end
savefig(p₁, joinpath(cd, "3608_2.png"))

cgrad(:darktest)
cgrad(:darktest, rev = true)

p₂ = heatmap(reshape(1:25, (5, 5)), color = cgrad(:viridis))
idx = LinRange(0, 1, 25)

for i ∈ 1:5
    for j ∈ 1:5
        p₂ = annotate!([j], [i], text(A[i,j], :center, 10, get(cgrad(:viridis, rev=true), idx[A[i,j]])))
    end
end
p₂
savefig(p₂, joinpath(cd, "3608_4.png"))


cgrad([:blue, :orange])
cgrad([:blue, :orange], [0.1, 0.9])
cgrad([:blue, :orange], [0.5, 0.50001])

cgrad(:darktest)
cgrad(:darktest, rev = true)

cgrad(:rainbow)
cgrad(:rainbow, scale = :log)
cgrad(:rainbow, scale = :exp)
using Plots

cwd = @__DIR__

ω₁ = LinRange(0, 4, 100)
ω₂ = LinRange(4, 7, 100)
ω₀ = 4

function A(ω, ω₀)
    if ω < ω₀
        return 1 ./ (ω₀^2 .- ω.^2)
    elseif ω > ω₀
        return 1 ./ (ω.^2 .- ω₀^2)
    else
        return Inf
    end
end

plot(ω₁, A.(ω₁, ω₀), label="ω < ω₀", xlabel="ω", ylabel="A(ω)")
plot!(ω₂, A.(ω₂, ω₀), label="ω > ω₀", xlabel="ω", ylabel="A(ω)", ylims=(0,3), size=(600,300), dpi=300)
savefig(joinpath(cwd, "1742.png"))

function damped_amplitude(ω, ω₀, γ)
    return 1 ./ sqrt((ω₀^2 .- ω.^2).^2 .+ 4(γ*ω).^2)
end

ω = LinRange(-0.5, 6, 200)
ω₀ = 2
γ = [4, 2, 1, 1/2, 1/4, 1/8]
γₛ = ["4", "2", "1", "1/2", "1/4", "1/8"]

p = plot(ω, damped_amplitude.(ω, ω₀, γ[1]), label="γ = $(γₛ[1])", xlabel="ω", ylabel="A(ω)", ylims=(0,1), size=(600,300), dpi=300)
for i ∈ 2:length(γ)
    plot!(ω, damped_amplitude.(ω, ω₀, γ[i]), label="γ = $(γₛ[i])", xlabel="ω", ylabel="A(ω)")
end
p
savefig(p, joinpath(cwd, "1742_2.png"))
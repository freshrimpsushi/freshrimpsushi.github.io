function dft_matrix(n)
    ω = exp(-2π*im/n)
    F = [ω^(i*j) for i in 0:n-1, j in 0:n-1]
    
    return F
end

function dft_matrix(n)
    return [exp(2π *im*i*j/n) for i in 0:n-1, j in 0:n-1]
end

using FFTW
using Plots

F = dft_matrix(128)
x = rand(128)

ξ = fft(x)
η = F*x

plot(
    plot(abs.(ξ), label="FFTW", c=:red, lw=2),
    plot(abs.(η), label="DFT matrix", c=:red, lw=2),
    plot(abs.(ξ .- η), label="Difference", c=:black, lw=2, ylims=(0, 2e-11)),
    layout=(3,1), size=(728,600), dpi=300
)
savefig(dir * "/1249_1.png")
dir = @__DIR__


using Tomography
p = phantom(256, 2)
heatmap(p, yflip=true, aspect_ratio=1, c=:viridis, dpi=300, size=(400,400), ylims=(0,256), xlims=(0,256))
dir = @__DIR__
savefig(dir * "/1249_2.png")


F = dft_matrix(256)
ξ = fft(p)
η = F*p*transpose(F)

plot(
    heatmap(abs.(ξ), yflip=true, aspect_ratio=1, c=:viridis, title="FFTW", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none, clims=(0, 150)),
    heatmap(abs.(η), yflip=true, aspect_ratio=1, c=:viridis, title="DFT matrix", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none, clims=(0, 150)),
    heatmap(abs.(ξ .- η), yflip=true, aspect_ratio=1, c=:viridis, title="Difference", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none, clims=(0, 150)),
    layout=(1,3), size=(1200,400), dpi=300
)
savefig(dir * "/1249_3.png")


function dft_inverse(F)
    n = size(F, 1)
    return conj(F) / n
end

F = dft_matrix(128)
x = rand(128)
F⁻¹ = dft_inverse(F)
plot(
    plot(x, label="Original signal x", lw=2, c=:royalblue1),
    plot(real(F⁻¹*F*x), label="Reconstructed signal F⁻¹*F*x", lw=2, c=:royalblue1),
    plot(abs.(x .- F⁻¹*F*x), label="Difference", lw=2, c=:black, ylims=(0, 1e-12)),
    layout = (3,1), size=(728,600), dpi=300
)
savefig(dir * "/1249_4.png")


p = phantom(256, 2)
F = dft_matrix(256)
F⁻¹ = dft_inverse(F)
p_reconstructed = F⁻¹*F*p*transpose(F)*transpose(F⁻¹)

plot(
    heatmap(p, yflip=true, aspect_ratio=1, c=:viridis, title="Original image", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none),
    heatmap(real(p_reconstructed), yflip=true, aspect_ratio=1, c=:viridis, title="Reconstructed image", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none),
    heatmap(abs.(p .- real(p_reconstructed)), yflip=true, aspect_ratio=1, c=:viridis, title="Difference", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none, clims=(0, 1e-10)),
    layout=(1,3), size=(1200,400), dpi=300
)
savefig(dir * "/1249_5.png")


function shifted_matrix(F)
    n2 = Int(size(F, 1) ÷ 2)
    S = cat(F[n2+1:end, :], F[1:n2, :], dims=1)

    return S
end

Fs = 1000                    #진동수
T = 1/1000                   #샘플링 간격
L = 1000                     #신호의 길이
x = [i for i in 0:L-1].*T    #신호의 도메인

F = dft_matrix(L)
S = shifted_matrix(F)

y₁ = sin.(2π*100*x)               #진동수가 100인 사인파
y₂ = 0.5sin.(2π*200*x)            #진동수가 100인 사인파
y₃ = 2sin.(2π*250*x)              #진동수가 100인 사인파
y = y₁ + y₂ + y₃ + randn(L)    #잡음이 섞인 신호

ξ = Fs*[i for i in 0:L-1]/L
plot(
    plot(ξ, abs.(F*y), c=:royalblue1, lw=2, label="DFT of the signal", xlabel="Frequency", ylabel="Amplitude"),
    plot(ξ .- 500, abs.(S*y), c=:royalblue1, lw=2, label="Shifted DFT of the signal", xlabel="Frequency", ylabel="Amplitude"),
    layout=(2,1), size=(728,400), dpi=300
)
savefig(dir * "/1249_6.png")

p = phantom(256, 2)
F = dft_matrix(256)
S = shifted_matrix(F)

ξ = F*p*transpose(F)
η = S*p*transpose(S)

plot(
    heatmap(abs.(ξ), yflip=true, clims=(0, 200), aspect_ratio=1, c=:viridis, title="DFT", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none),
    heatmap(abs.(η), yflip=true, clims=(0, 200), aspect_ratio=1, c=:viridis, title="Shifted DFT", size=(400,400), xlims=(0,256), ylims=(0,256), colorbar=:none),
    layout=(1,2), size=(728,400), dpi=300
)
savefig(dir * "/1249_7.png")




pt = Plots.pt
F = dft_matrix(256)
heatmap(abs.(F), yflip=true, aspect_ratio=1, c=:viridis, title="Visualization DFT matrix",
size=(600,600), xlims=(0,256), ylims=(0,256), xlabel="j", ylabel="i", colorbar=:none)
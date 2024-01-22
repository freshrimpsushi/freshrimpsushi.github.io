using Pkg

Pkg.add("FFTW")
Pkg.add("LaTeXStrings")
Pkg.add("Tomography")

using FFTW
using Plots
using LaTeXStrings

Fs = 1000 #진동수
T = 1/1000 #샘플링 간격
L = 1000 #신호의 길이
x = [i for i in 0:L-1].*T #신호의 도메인

f₁ = sin.(2π*100*x) #진동수가 100인 사인파
f₂ = 0.5sin.(2π*200*x) #진동수가 100인 사인파
f₃ = 2sin.(2π*350*x) #진동수가 100인 사인파
f = f₁ + f₂ + f₃

Fs = 1000 # 샘플링 주파수
ℱf = fft(f) # 푸리에 변환
ξ = Fs*[i for i in 0:L-1]/L #주파수 도메인(절반)
plot(ξ[1:Int(L/2)], abs.(ℱf[1:Int(L/2)])*2/L, title=L"Fourier transform of $f$", label="") 
# xticks!([0, 100, 200, 350, 500, 650, 800, 900, 1000])
xlabel!("frequency")
ylabel!("amplitude")
savefig("fft.png")

p₁ = plot(ξ, abs.(ℱf), title=L"$\mathcal{F}f$", label="", yticks=[], xticks=[0, 100, 200, 350, 500, 1000]) 
p₂ = plot(ξ.-500, abs.(fftshift(ℱf)), title=L"$\mathrm{fftshift}(\mathcal{F}f)$", label="", yticks=[], xticks=[-500,-350,-200,-100,0,100,200,350,500]) 
plot(p₁, p₂, size=(800,400))
savefig("fftshift.png")


using Tomography

x = [1.0; 2; 3; 4]
fft(x)

y = [x x x x]
fft(y)
fft(y, [1, 2])

fft(y, [1])
fft(y, [2])

ℱX = fft(X)
heatmap(abs.(ℱX))

fftfreq(4, 1)
fftfreq(5, 1)
fftshift(fftfreq(4, 1))
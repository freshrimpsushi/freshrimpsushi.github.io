using Plots
using FFTW

# Initialization
U = zeros(Float64, 256, 256, 256)

# x ∈ [-1, 1]
# t ∈ [0, 2]
Δt = 1/256

for i ∈ 1:256, j ∈ 1:256
    if 10^2 < (i-80-64)^2 + (j-80-64)^2 < 12^2
        U[i, j, 1] = 1
        U[i, j, 2] = 1
    end
    if (i-45-64)^2 + (j-45-64)^2 < 4^2
        U[i, j, 1] = 1
        U[i, j, 2] = 1
    end
end

w2b = cgrad([:white, :black])

# make k-space grid
k = LinRange(-128., 128, 256) * π
k1 = k * fill!(similar(k'), 1)
k2 = fill!(similar(k), 1) * k'

K = sqrt.(k1.^2 + k2.^2)
K = 4 * (sin.(Δt * K/2)).^2
K = ifftshift(K)


# heatmap(K2, c=w2b)
# heatmap(ifftshift(K2), c=w2b)
# heatmap(ifftshift(K), c=w2b)
# heatmap(abs.((fft(U[:, :, 1]))), c=w2b)
# heatmap(real(ifft((K2 .* (fft(U[:, :, 1]))))), c=w2b)
# heatmap(real(ifft(ifftshift(K .* fft(U[:, :, 1])))), c=w2b)
# heatmap(real(ifft(fftshift(K .* fft(U[:, :, 1])))), c=w2b)

# begin
#     N=5
#     U[:, :, N] = 2U[:, :, N-1] - U[:, :, N-2] - real(ifft(K .* (fft(U[:, :, N-1]))))
#     heatmap(U[:, :, N], clim=(0,1), c=w2b)
# end

for i ∈ 3:256
    U[:, :, i] = 2U[:, :, i-1] - U[:, :, i-2] - real(ifft(K .* fft(U[:, :, i-1])))
end

anim = @animate for i ∈ 1:180
    if i < 31
        heatmap(U[:,:,1], c=w2b, clim=(0,1), dpi=300, framestyle=:none, colorbar=:none, raio=1)
    else
        heatmap(U[:,:,i-30], c=w2b, clim=(0,1), dpi=300, framestyle=:none, colorbar=:none, raio=1)
    end
end
cd = @__DIR__
gif(anim, cd*"./1627.gif", fps=45)
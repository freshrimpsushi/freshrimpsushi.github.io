using Plots

path = @__DIR__

x = LinRange(-1, 1, 300)
Δx = x[2] - x[1]

t = LinRange(0, 4, 600)
Δt = t[2] - t[1]

μ = Δt / Δx
C = (μ - 1) / (μ + 1)

U = zeros(length(x), length(t))

U[:, 1] = exp.(-30 * x.^2)
U[:, 2] = exp.(-30 * x.^2)

for i ∈ 3:length(t) # without ABCs
    U[2:end-1, i] = (μ^2)*U[3:end, i-1] + 2(1-μ^2)*U[2:end-1, i-1] + (μ^2)*U[1:end-2, i-1] - U[2:end-1, i-2]
end

heatmap(U)

anim = @animate for i ∈ 1:length(t)
    plot(x, U[:, i], xlims=(-1, 1), ylims=(-2,2), legend=false)
end

gif(anim, path*"./1631_1.gif", fps=50)

V = zeros(length(x), length(t))
V[:, 1] = exp.(-30 * x.^2)
V[:, 2] = exp.(-30 * x.^2)

for i ∈ 3:length(t)
    V[2:end-1, i] = (μ^2)*V[3:end, i-1] + 2(1-μ^2)*V[2:end-1, i-1] + (μ^2)*V[1:end-2, i-1] - V[2:end-1, i-2]
    V[1, i] = V[2, i-1] + C*(V[2, i] - V[1, i-1])
    V[end, i] = V[end-1, i-1] + C*(V[end-1, i] - V[end, i-1])
end

heatmap(V)

anim = @animate for i ∈ 1:length(t)
    plot(x, V[:, i], xlims=(-1, 1), ylims=(-2,2), legend=false)
end

gif(anim, path*"./1631_2.gif", fps=50)

anim3 = @animate for i ∈ 1:3:Int(length(t)/2)
    p1 = plot(x, U[:, i], xlims=(-1, 1), ylims=(-1,1), lw = 2, legend=false, dpi=300, title = "w/o ABCs")
    p2 = plot(x, V[:, i], xlims=(-1, 1), ylims=(-1,1), lw = 2, legend=false, dpi=300, title = "w/ ABCs")
    plot(p1, p2, layout=(2,1), size = (728, 400))
    annotate!(1, 1, text("t=$(round(t[i], digits=2))", :black, :right, 13))
end
gif(anim3, path*"./1631_1.gif", fps=35)

# 2차원
using FFTW

U₂ = zeros(Float64, 256, 256, 256)

Δt₂ = 1/256
μ₂ = 0.02
C₂ = 1/2

for i ∈ 1:256, j ∈ 1:256
    if 10^2 < (i-80-64)^2 + (j-80-64)^2 < 12^2
        U₂[i, j, 1] = 1
        U₂[i, j, 2] = 1
    end
    if (i-45-64)^2 + (j-45-64)^2 < 4^2
        U₂[i, j, 1] = 1
        U₂[i, j, 2] = 1
    end
end

anim = @animate for n in 1:nt
    heatmap(U₂[:, :, n], c=:viridis, color=:blue, clims=(-1, 1))
end

gif(anim, fps=50)


# for i ∈ 3:256
#     U₂[2:end-1, 2:end-1, i] = 2U₂[2:end-1, 2:end-1, i-1] - U₂[2:end-1, 2:end-1, i-2] + μ₂^2(U₂[3:end, 2:end-1, i-1] + U₂[1:end-2, 2:end-1, i-1] + U₂[2:end-1, 3:end, i-1] + U₂[2:end-1, 1:end-2, i-1] - 4U₂[2:end-1, 2:end-1, i-1])
# end

w2b = cgrad([:white, :black])

# make k-space grid
k = LinRange(-128., 128, 256) * π
k1 = k * fill!(similar(k'), 1)
k2 = fill!(similar(k), 1) * k'

K = sqrt.(k1.^2 + k2.^2)
K = 4 * (sin.(Δt₂ * K/2)).^2
K = ifftshift(K)

for i ∈ 3:256
    U₂[:, :, i] = 2U₂[:, :, i-1] - U₂[:, :, i-2] - real(ifft(K .* fft(U₂[:, :, i-1])))
end

anim = @animate for i ∈ 1:256
    if i < 31
        heatmap(U₂[:,:,1], c=w2b, clim=(0,1), dpi=300, framestyle=:none, colorbar=:none, raio=1)
    else
        heatmap(U₂[:,:,i-30], c=w2b, clim=(0,1), dpi=300, framestyle=:none, colorbar=:none, raio=1)
    end
end
gif(anim, path*"./1631_2.gif", fps=45)

V₂ = zeros(Float64, 256, 256, 256)
for i ∈ 1:256, j ∈ 1:256
    if 10^2 < (i-80-64)^2 + (j-80-64)^2 < 12^2
        V₂[i, j, 1] = 1
        V₂[i, j, 2] = 1
    end
    if (i-45-64)^2 + (j-45-64)^2 < 4^2
        V₂[i, j, 1] = 1
        V₂[i, j, 2] = 1
    end
end

for i ∈ 3:256
    V₂[:, :, i] = 2V₂[:, :, i-1] - V₂[:, :, i-2] - real(ifft(K .* fft(V₂[:, :, i-1])))
    
    V₂[1, 2:end-2, i] = V₂[2, 2:end-2, i-1] + C₂*(V₂[2, 2:end-2, i] - V₂[1, 2:end-2, i-1])
    V₂[end, 2:end-2, i] = V₂[end-1, 2:end-2, i-1] + C₂*(V₂[end-1, 2:end-2, i] - V₂[end, 2:end-2, i-1])
    V₂[2:end-2, 1, i] = V₂[2:end-2, 2, i-1] + C₂*(V₂[2:end-2, 2, i] - V₂[2:end-2, 1, i-1])
    V₂[2:end-2, end, i] = V₂[2:end-2, end-1, i-1] + C₂*(V₂[2:end-2, end-1, i] - V₂[2:end-2, end, i-1])
end

anim2 = @animate for i ∈ 1:3:256
    # if i < 31
    #     heatmap(V₂[:,:,1], c=w2b, clim=(0,1), dpi=300, framestyle=:none, colorbar=:none, raio=1)
    # else
        heatmap(V₂[:,:,i], c=w2b, clim=(0,1), dpi=300, framestyle=:none, colorbar=:none, raio=1)
    # end
end
gif(anim2, fps=50)


# begin
using Plots

# 파라미터 설정
nx, ny = 200, 200  # 격자 크기
nt = 400  # 시간 스텝 수
Lx, Ly = 10.0, 10.0  # 공간 영역 크기
T = 10.0  # 총 시간
c = 1.0  # 파동 속도

dx = Lx / (nx - 1)
dy = Ly / (ny - 1)
dt = T / (nt - 1)
κ = c * dt / dx

# 초기 조건 설정
u = zeros(Float64, nx, ny, nt)
v = zeros(Float64, nx, ny, nt)

U = zeros(Float64, nx, ny, nt)
for i ∈ 1:nx, j ∈ 1:ny
    if 13^2 < (i-160)^2 + (j-160)^2 < 15^2
        u[i, j, 1] = 1
        u[i, j, 2] = 1

        v[i, j, 1] = 1
        v[i, j, 2] = 1
        
        U[i, j, 1] = 1
        U[i, j, 2] = 1
    end
    if (i-40)^2 + (j-40)^2 < 4^2
        u[i, j, 1] = 1
        u[i, j, 2] = 1
        
        v[i, j, 1] = 1
        v[i, j, 2] = 1

        U[i, j, 1] = 1
        U[i, j, 2] = 1
    end
end


# 유한 차분법 계산
for n in 3:(nt - 1)
    for i in 2:(nx - 1)
        for j in 2:(ny - 1)
            u_xx = (u[i + 1, j, n] - 2 * u[i, j, n] + u[i - 1, j, n]) / dx^2
            u_yy = (u[i, j + 1, n] - 2 * u[i, j, n] + u[i, j - 1, n]) / dy^2
            u[i, j, n + 1] = 2 * u[i, j, n] - u[i, j, n - 1] + c^2 * dt^2 * (u_xx + u_yy)
        end
    end
end
anim2 = @animate for n in 1:nt
    heatmap(u[:, :, n], c=:viridis, color=:blue, clim=(min,max))
end
gif(anim2, fps=50)

for n in 2:(nt - 1)
    u_xx = (u[3:end, 2:end-1, n] - 2 * u[2:end-1, 2:end-1, n] + u[1:end-2, 2:end-1, n]) / dx^2
    u_yy = (u[2:end-1, 3:end, n] - 2 * u[2:end-1, 2:end-1, n] + u[2:end-1, 1:end-2, n]) / dy^2
    u[2:end-1, 2:end-1, n + 1] = 2 * u[2:end-1, 2:end-1, n] - u[2:end-1, 2:end-1, n - 1] + c^2 * dt^2 * (u_xx + u_yy)

    v_xx = (v[3:end, 2:end-1, n] - 2 * v[2:end-1, 2:end-1, n] + v[1:end-2, 2:end-1, n]) / dx^2
    v_yy = (v[2:end-1, 3:end, n] - 2 * v[2:end-1, 2:end-1, n] + v[2:end-1, 1:end-2, n]) / dy^2
    v[2:end-1, 2:end-1, n + 1] = 2 * v[2:end-1, 2:end-1, n] - v[2:end-1, 2:end-1, n - 1] + c^2 * dt^2 * (v_xx + v_yy)

    u[1, 2:end-1, n+1] = u[2, 2:end-1, n] + ((κ-1)/(κ+1))*(u[2, 2:end-1, n] - u[1, 2:end-1, n-1])
    u[end, 2:end-1, n+1] = u[end-1, 2:end-1, n] + ((κ-1)/(κ+1))*(u[end-1, 2:end-1, n] - u[end, 2:end-1, n-1])
    u[2:end-1, 1, n+1] = u[2:end-1, 2, n] + ((κ-1)/(κ+1))*(u[2:end-1, 2, n] - u[2:end-1, 1, n-1])
    u[2:end-1, end, n+1] = u[2:end-1, end-1, n] + ((κ-1)/(κ+1))*(u[2:end-1, end-1, n] - u[2:end-1, end, n-1])
end

b2r = cgrad([:blue, :white, :red])

# 애니메이션 생성
anim2 = @animate for n in 1:nt
    p1 = heatmap(u[:, :, n], c=b2r, clim=(-1,1), legend=false, xticks=false, yticks=false, framestyle=:box, ratio=1, dpi=200, title="w/ ABCs")
    p2 = heatmap(v[:, :, n], c=b2r, clim=(-1,1), legend=false, xticks=false, yticks=false, framestyle=:box, ratio=1, dpi=200, title="w/o ABCs")
    plot(p1, p2, layout=(1,2), size=(728, 728/2))
end


gif(anim2, path*"1631_2.gif", fps=50)


# k-space method
k = LinRange(-nx/2., nx/2, nx) * π
k1 = k * fill!(similar(k'), 1)
k2 = fill!(similar(k), 1) * k'

K = sqrt.(k1.^2 + k2.^2)
K = 4 * (sin.(dt * K/2)).^2
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

for i ∈ 3:nt
    U[:, :, i] = 2U[:, :, i-1] - U[:, :, i-2] - real(ifft(K .* fft(U[:, :, i-1])))

    U[1, 2:end-1, i] = U[2, 2:end-1, i-1] + ((κ-1)/(κ+1))*(U[2, 2:end-1, i-1] - U[1, 2:end-1, i-2])
    U[end, 2:end-1, i] = U[end-1, 2:end-1, i-1] + ((κ-1)/(κ+1))*(U[end-1, 2:end-1, i-1] - U[end, 2:end-1, i-2])
    U[2:end-1, 1, i] = U[2:end-1, 2, i-1] + ((κ-1)/(κ+1))*(U[2:end-1, 2, i-1] - U[2:end-1, 1, i-2])
    U[2:end-1, end, i] = U[2:end-1, end-1, i-1] + ((κ-1)/(κ+1))*(U[2:end-1, end-1, i-1] - U[2:end-1, end, i-2])
end

anim = @animate for i ∈ 1:50
    heatmap(U[:,:,i], c=b2r, clim=(-1,1), dpi=300, framestyle=:none, colorbar=:none, raio=1)
end
gif(anim, fps=20)
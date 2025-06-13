# ----------------- Packages --------------------------------------------------
using Images, FileIO, Random, Statistics, Plots, ImageShow

# ----------------- Hyper‑parameters (DDPM default) ---------------------------
T            = 1000                         # total diffusion steps
betas        = range(1e-4, 0.02; length=T)  |> collect
alphas       = 1 .- betas
alphabars    = accumulate(*, alphas)        #  \bar{α}_t

# ----------------- Load & scale image x₀ ∈ [-1, 1] ---------------------------
# img0         = load("./content/j_/0_recent/0000homework/3638_DDPM/3638_0.png") |> channelview       # (C,H,W)
img0         = load("D:/admin/content/j_/ive/머신러닝/3638_DDPM/3638_00.png") |> channelview       # (C,H,W)
# img0         = load("./3638_0.png") |> channelview       # (C,H,W)
img0_f       = Float32.(img0) ./ 1f0 .* 2f0 .- 1f0    # scale to [-1,1]
# img0_f       = Float32.(img0)
x0           = permutedims(img0_f, (2,3,1))             # (H,W,C)

img_CHW = permutedims(x0[:,:,1:3], (3,1,2))   # (3,H,W)
rgb_img = colorview(RGB, img_CHW)

# ----------------- Allocate tensor to hold all x_t ---------------------------
H,W,C        = size(x0)
xts          = Array{Float32}(undef, H, W, C, T+1)
xts[:,:,:,1] .= x0                                        # store x₀

# ----------------- Forward diffusion loop ------------------------------------
x_prev = x0
rng     = MersenneTwister()                               # reproducible

for t in 1:T
    global x_prev

    β  = betas[t]
    α  = alphas[t]
    ε  = randn!(rng, similar(x_prev))                    # ε ∼ 𝒩(0,I)
    x_t = √α .* x_prev .+ √β .* ε                       # q(x_t | x_{t-1})
    xts[:,:,:,t+1] .= x_t                                # save
    x_prev = x_t
end

# ----------------- xts now contains x₀,…,x_T -------------------------------
# xts[:,:,:,k] == x_{k-1}
t_view = 1                    # 보고 싶은 스텝
x_t    = xts[:,:,:,t_view + 1]    # (H,W, C)
# -------- [-1,1] → [0,1],  C 확인 ------------------------------------------
img01 = clamp.((x_t .+ 1f0) .* 0.5f0, 0f0, 1f0)   # Float32 in [0,1]
H,W,C = size(img01)
# -------- 알파 채널(4번째) 있으면 잘라내기 ---------------------------------
if C == 4
    img01 = img01[:,:,1:3]   # RGB 만 사용
end
# -------- H,W,C  →  C,H,W 로 바꿔서 colorview ------------------------------
img_CHW = permutedims(img01, (3,1,2))   # (3,H,W)
rgb_img = colorview(RGB, img_CHW)       # reinterpret 성공
display(rgb_img)                        # 노트북/REPL 표시

function show_img(t_view, xts, cd, num)
    x_t = xts[:,:,:,t_view]    # (H,W, C)
    x_t = clamp.((x_t .+ 1f0) .* 0.5f0, 0f0, 1f0)
    # map(clamp01nan, x_t)
    # -------- [-1,1] → [0,1],  C 확인 ------------------------------------------
    H,W,C = size(xts)
    # -------- 알파 채널(4번째) 있으면 잘라내기 ---------------------------------
    if C == 4
        x_t = x_t[:,:,1:3]   # RGB 만 사용
    end
    # -------- H,W,C  →  C,H,W 로 바꿔서 colorview ------------------------------
    img_CHW = permutedims(x_t, (3,1,2))   # (3,H,W)
    rgb_img = colorview(RGB, img_CHW)       # reinterpret 성공
    # display(rgb_img)
    filename = joinpath(cd, "asdf_$(t_view).png")
    save(filename, rgb_img)
end

cd = @__DIR__
show_img(1, xts)
# save(cd*"./3638_1.png", rgb_img)   # save as png
show_img(1000, xts, cd, 2)
save(cd*"./asd8_3.png", rgb_img)

# show_img(100, xts)
show_img(1, xts, cd, 2)
save(cd*"./asd8_3.png", rgb_img)   # save as png

show_img(150, xts)
save(cd*"./asd8_4.png", rgb_img)   # save as png

show_img(300, xts)
save(cd*"./asd8_5.png", rgb_img)   # save as png

show_img(500, xts)
save(cd*"./asd8_6.png", rgb_img)   # save as png


show_img(1000, xts)
save(cd*"./asd8_7.png", rgb_img)   # save as png
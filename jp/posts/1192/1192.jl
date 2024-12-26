using Tomography
using Plots


p = phantom(512, 2)
n = 0.1randn(512, 512)

h1 = heatmap(p, yflip = true, colorbar=false, title="The original", showaxis=false, ratio=1, color=:grays)
h2 = heatmap(p+n, yflip = true, colorbar=false, title="Noisy image", showaxis=false, ratio=1, color=:grays)

plot(h1, h2, layout=(1,2), size=(800,400), dpi=300)



using ImageFiltering

# 가우시안 커널 생성 함수
function create_gaussian_kernel(size::Int, sigma::Float64)
    x = -div(size, 2):div(size, 2)
    y = -div(size, 2):div(size, 2)
    kernel = [exp(-(x^2 + y^2) / (2 * sigma^2)) for x in x, y in y]
    kernel ./= sum(kernel)  # 정규화
    return kernel
end

# 가우시안 블러 처리 함수
function apply_gaussian_blur(array::Array{Float64}, kernel_size::Int, sigma::Float64)
    kernel = create_gaussian_kernel(kernel_size, sigma)
    blurred_array = imfilter(array, kernel, "replicate")  # 경계 처리
    return blurred_array
end

# 테스트용 원본 이미지 배열 생성
original_array = p

# 가우시안 블러 적용
kernel_size = 30  # 커널 크기
sigma = 6.0       # 표준 편차
blurred_array = apply_gaussian_blur(original_array, kernel_size, sigma)

# 결과 출력
h3 = plot(heatmap(original_array, yflip=true, color=:grays, colorbar=false, ratio=1, title="The Original "), showaxis = false)
h4 = plot(heatmap(blurred_array, yflip=true, color=:grays, colorbar=false, ratio=1, title="Blurred image"), showaxis = false)
plot(h3, h4, layout=(1,2), size=(800,400), dpi=300)
savefig("./content/j_/0_recent/1192_노이즈아티팩트/1192_4.png")